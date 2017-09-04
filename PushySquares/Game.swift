

public class Game {
    public var board: Array2D<Tile>
    public var spawnpoints: [Color: Position]
    public var players = [Player]()
    public var currentPlayer: Player {
        return players[currentPlayerIndex]
    }
    
    private var currentPlayerIndex = 0
    
    public weak var delegate: GameDelegate?
    
    public init(map: Map, playerCount: Int, lives: Int = 5) {
        self.board = map.board
        self.spawnpoints = map.spawnpoints
        switch playerCount {
        case 4:
            players.append(Player(turnsUntilNewSquare: playerCount + 1, lives: lives, color: .color4))
            spawnNewSquare(color: .color4)
            fallthrough
        case 3:
            players.append(Player(turnsUntilNewSquare: playerCount + 1, lives: lives, color: .color2))
            spawnNewSquare(color: .color2)
            fallthrough
        case 2:
            players.append(Player(turnsUntilNewSquare: playerCount + 1, lives: lives, color: .color1))
            players.append(Player(turnsUntilNewSquare: playerCount + 1, lives: lives, color: .color3))
            spawnNewSquare(color: .color1)
            spawnNewSquare(color: .color3)
        default:
            fatalError()
        }
        
        if playerCount < 4 {
            spawnpoints[.color4] = nil
        }
        
        if playerCount < 3 {
            spawnpoints[.color2] = nil
        }
    }
    
    public func moveUp() {
    }
    
    private func move(displacement displace: (Position) -> Position, sorter: (Position, Position) -> Bool) {
        let allSquaresPositions = board.indicesOf(color: currentPlayer.color)
        var movingSquaresPositions = [Position]()
        var beingDestroyedSquaresPositions = [Position]()
        for position in allSquaresPositions {
            var pushedPositions = [position]
            loop: while true {
                switch board[displace(pushedPositions.last!)] {
                case .empty:
                    break loop
                case .wall:
                    pushedPositions = []
                    break loop
                case .void:
                    beingDestroyedSquaresPositions.append(pushedPositions.last!)
                    break loop
                case .square:
                    pushedPositions.append(displace(pushedPositions.last!))
                }
            }
            movingSquaresPositions.append(contentsOf: pushedPositions)
        }
        let sortedPositions = movingSquaresPositions.sorted(by: sorter)
        for position in sortedPositions {
            let tile = board[position]
            board[position] = .empty
            if !beingDestroyedSquaresPositions.contains(position) {
                board[displace(position)] = tile
            }
        }
        delegate?.squaresDidMove(originalPositions: movingSquaresPositions, destroyedSquarePositions: beingDestroyedSquaresPositions)
    }
    
    private func spawnNewSquare(color: Color) {
        board[spawnpoints[color]!] = .square(color)
        delegate?.squareDidSpawn(color: color)
    }
}
