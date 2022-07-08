enum GameState {
    case notStarted
    case running
    case over
}

protocol GameLoopDelegate: AnyObject {
    func gameStateDidChange(toNewState gameState: GameState)
    func playerDidMove(toPosition position: TilePosition)
}

final class GameLoop {
    typealias LevelFactory = (Int) -> Level
    typealias MoveFinder = (Level) -> TilePosition
    
    private let levelFactory: LevelFactory
    private let moveFinder: MoveFinder
    
    private(set) var level: Level?
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
    
    init(
        levelFactory: @escaping LevelFactory,
        moveFinder: @escaping MoveFinder
    ) {
        self.levelFactory = levelFactory
        self.moveFinder = moveFinder
    }
    
    func start() {
        levelsPassed = 0
        level = levelFactory(levelsPassed)
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
        let nextMove = moveFinder(level)
        level.movePlayer(toPosition: nextMove)
        delegate?.playerDidMove(toPosition: nextMove)
    }
}
