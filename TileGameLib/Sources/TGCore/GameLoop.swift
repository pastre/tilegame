public enum GameState {
    case notStarted
    case running
    case over
}

public protocol GameLoopDelegate: AnyObject {
    func gameStateDidChange(toNewState gameState: GameState)
    func playerDidMove(toPosition position: TilePosition)
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
    
    weak var delegate: GameLoopDelegate? {
        didSet {
            delegate?.gameStateDidChange(toNewState: currentGameState)
        }
    }
    
    public convenience init() {
        self.init(
            levelFactory: .default,
            exitFinder: .usingDjikstra
        )
    }
    
    init(
        levelFactory: LevelMaker,
        exitFinder: ExitFinder
    ) {
        self.levelFactory = levelFactory
        self.exitFinder = exitFinder
        
        start()
    }
    
    func start() {
        levelsPassed = 0
        level = levelFactory.make(levelsPassed)
        currentGameState = .running
    }
    
    func removeTile(atPosition position: TilePosition) {
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
        delegate?.playerDidMove(toPosition: nextMove)
    }
}
