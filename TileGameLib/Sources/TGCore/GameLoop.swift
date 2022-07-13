public enum GameState {
    case notStarted
    case running
    case over
}

public protocol GameLoopDelegate: AnyObject {
    func gameStateDidChange(toNewState gameState: GameState)
    func playerDidMove(_ level: Level, toPosition position: TilePosition)
}

public final class GameLoop {
    private let levelFactory: LevelMaker
    private let exitFinder: ExitFinder
    
    public private(set) var level: Level?
    private var levelsPassed = 0
    private var currentGameState: GameState = .notStarted {
        didSet {
            delegate?.gameStateDidChange(toNewState: currentGameState)
        }
    }
    
    public weak var delegate: GameLoopDelegate? {
        didSet {
            delegate?.gameStateDidChange(toNewState: currentGameState)
        }
    }
    
    public convenience init(levelFactory: LevelMaker? = nil) {
        self.init(
            levelFactory: levelFactory ?? .default,
            exitFinder: .usingAStar
        )
    }
    
    init(
        levelFactory: LevelMaker,
        exitFinder: ExitFinder
    ) {
        self.levelFactory = levelFactory
        self.exitFinder = exitFinder
    }
    
    public func start() {
        levelsPassed = 0
        createNewLevel()
        currentGameState = .running
    }
    
    public func createNewLevel() {
        level = levelFactory.make(levelsPassed)
        if let playerStartPosition = level?.board.rows.enumerated().flatMap({ (j, row) in
            row.enumerated().compactMap { (i, tile) -> TilePosition? in
                if tile != .floor { return nil }
                return TilePosition(x: i, y: j)
            }
        }).randomElement() {
            level?.movePlayer(toPosition: playerStartPosition)
        }
    }
    
    public func removeTile(atPosition position: TilePosition) {
        guard let level = level else {
            return
        }

        level.removeTile(atPosition: position)
        if level.isGameOver() {
            currentGameState = .over
            return
        }
        movePlayer(onLevel: level)
    }
    
    private func movePlayer(onLevel level: Level) {
        guard let nextMove = exitFinder.find(level)
        else { return }
        level.movePlayer(toPosition: nextMove)
        delegate?.playerDidMove(level, toPosition: nextMove)
    }
}
