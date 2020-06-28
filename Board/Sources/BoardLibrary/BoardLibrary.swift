struct PlayerChip {
    var position: String
    var color: String = "●"

    init(position: String){
        self.position = position
    }
}

protocol Edge {
    var neighbours: [Int] {get set}
    var isEmpty: Bool {get set}
    var chip: PlayerChip? {get set}

    func edgeToString() -> String
    func setPlayer(chip:PlayerChip?) -> Void
    func removePlayer(chip:PlayerChip?) -> Void
}

class BoardEdge: Edge {
    var neighbours: [Int] = []
    var isEmpty = true
    var chip: PlayerChip?

    init(neighbours: [Int]){
        self.neighbours = neighbours
    }

    func setPlayer(chip:PlayerChip?){
        self.chip = chip
        self.isEmpty = false
    }

    func removePlayer(chip:PlayerChip?){
        self.chip = nil
        self.isEmpty = true
    }

    func edgeToString() -> String {
        guard let playerChip = self.chip else {
            return "."
        }

        return playerChip.color
    }
}

protocol Board {
    var edges: [Edge] {get set}

    func printBoard() -> Void
    func initEdges() -> [Edge]
}

class GameBoard: Board {
    // each edge has a neighbours. In this array they are mapped as edge index -> neighbours
    // edge with index 0 will be the top right corner, edge with index one will be the second edge on the first row, etc.
    static let edgesNeighbours = [
        [1, 9],
        [0, 2, 4],
        [1, 14],
        [4, 10],
        [1, 3, 5, 7],
        [4, 13],
        [7, 11],
        [4, 6, 8],
        [7, 12],
        [0, 10, 21],
        [3, 9, 11, 18],
        [6, 10, 15],
        [8, 13, 17],
        [5, 12, 14, 20],
        [2, 13, 23],
        [11, 16],
        [15, 17, 19],
        [12, 16],
        [10, 19],
        [16, 18, 20, 22],
        [13, 19],
        [9, 22],
        [19, 21, 23],
        [14, 22]
    ]

    var edges:[Edge] = []

    init(edges: [Edge]) {
        self.edges = edges
    }

    init() {
        self.edges = initEdges()
    }

    func initEdges() -> [Edge] {
        var edges: [Edge] = []

        for neighbours in GameBoard.edgesNeighbours {
            edges.append(BoardEdge(neighbours: neighbours))
        }

        return edges
    }

    func printBoard() {
        print("\(edges[0].edgeToString())---------\(edges[1].edgeToString())---------\(edges[2].edgeToString())")
        print("|         |         |")
        print("|  \(edges[3].edgeToString())------\(edges[4].edgeToString())------\(edges[5].edgeToString())  |")
        print("|  |      |      |  |")
        print("|  |   \(edges[6].edgeToString())--\(edges[7].edgeToString())--\(edges[8].edgeToString())   |  |")
        print("|  |   |     |   |  |")
        print("\(edges[9].edgeToString())--\(edges[10].edgeToString())---\(edges[11].edgeToString())     \(edges[12].edgeToString())---\(edges[13].edgeToString())--\(edges[14].edgeToString())")
        print("|  |   |     |   |  |")
        print("|  |   \(edges[15].edgeToString())--\(edges[16].edgeToString())--\(edges[17].edgeToString())   |  |")
        print("|  |      |      |  |")
        print("|  \(edges[18].edgeToString())------\(edges[19].edgeToString())------\(edges[20].edgeToString())  |")
        print("|         |         |")
        print("\(edges[21].edgeToString())---------\(edges[22].edgeToString())---------\(edges[23].edgeToString())")
    }
}

//test board printing
// let board = GameBoard()
// print("\(board.printBoard())")