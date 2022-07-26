public protocol GameLoopDelegate: AnyObject {
    func gameStateDidChange(toNewState gameState: GameState)
    func playerDidMove(_ level: Level, toPosition position: TilePosition)
}

public protocol GameLoopProtocol: AnyObject {
    var delegate: GameLoopDelegate? { get set }
    var level: Level { get }
    
    func start()
    func removeTile(atPosition: TilePosition)
}

public final class GameLoop: GameLoopProtocol {
    private let levelFactory: LevelMaker
    private let exitFinder: ExitFinder
    
    public private(set) var level: Level
    public private(set) var levelsPassed = 0
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
        self.level = levelFactory.make(levelsPassed)
    }
    
    public func start() {
        levelsPassed = 0
        createNewLevel()
    }
    
    public func createNewLevel() {
        let level = levelFactory.make(levelsPassed)
        if let playerStartPosition = level.board.rows.enumerated().flatMap({ (j, row) in
            row.enumerated()
                .filter { _, tile in tile == .floor }
                .map { (i, _) in TilePosition(x: i, y: j) }
        }).randomElement() {
            level.movePlayer(toPosition: playerStartPosition)
        }
        self.level = level
        currentGameState = .running
    }
    
    public func removeTile(atPosition position: TilePosition) {
        level.removeTile(atPosition: position)
        if level.isGameOver() {
            currentGameState = .over
            return
        }
        movePlayer(onLevel: level)
    }
    
    private func movePlayer(onLevel level: Level) {
        guard let nextMove = exitFinder.find(level)
        else {
            levelsPassed += 1
            currentGameState = .won
            return
        }
        level.movePlayer(toPosition: nextMove)
        delegate?.playerDidMove(
            level,
            toPosition: nextMove)
    }
}
