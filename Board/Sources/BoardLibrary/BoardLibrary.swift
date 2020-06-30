import PlayerLibrary

protocol Edge {
    var position: String {get set}
    var neighbours: [Int] {get set}
    var isEmpty: Bool {get set}
    var chip: PlayerChip? {get set}

    func edgeToString() -> String
    func setPlayer(chip:PlayerChip?) -> Void
    func removePlayer(chip:PlayerChip?) -> Void
}

class BoardEdge: Edge {
    var neighbours: [Int] = []
    var position: String
    var isEmpty = true
    var chip: PlayerChip?

    init(_ position: String,_ neighbours: [String]){
        self.neighbours = neighbours
        self.position = position
    }

    init(position: String){
        self.position = position
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

        return playerChip.color.toString()
    }
}

protocol Board {
    var edges: [Edge] {get set}

    func printBoard() -> Void
    func initEdges() -> [Edge]
}

public class GameBoard: Board {
    // each edge has a neighbours. In this array they are mapped as edge index -> neighbours
    // edge with index 0 will be the top right corner, edge with index one will be the second edge on the first row, etc.
    let edges:[String:Edge] = [
        "A1": Edge("A1", ["D1", "A4"]),            //0
        "D1": Edge("D1", ["A1", "G1", "D2"]),         //1
        "G1": Edge("G1", ["D1", "G4"]),           //2
        "B2": Edge("B2", ["D2", "B4"]),           //3
        "D2": Edge("D2", ["D1", "B2", "F2", "D3"]),      //4
        "F2": Edge("F2", ["D2", "F4"]),           //5
        "C3": Edge("C3", ["D3", "C4"]),           //6
        "D3": Edge("D3", ["D2", "C3", "F3"]),         //7
        "F3": Edge("F3", ["D3", "E4"]),           //8
        "A4": Edge("A4", ["A1", "B4", "A7"]),       //9
        "B4": Edge("B4", ["B2", "A4", "C4", "B6"]),    //10
        "C4": Edge("C4", ["C3", "B4", "C5"]),       //11
        "E4": Edge("E4", ["F3", "F4", "E5"]),       //12
        "F4": Edge("F4", ["F2", "E4", "G4", "F6"]),   //13
        "G4": Edge("G4", ["G1", "F4", "G7"]),       //14
        "C5": Edge("C5", ["C4", "D5"]),          //15
        "D5": Edge("D5", ["C5", "E5", "D6"]),      //16
        "E5": Edge("E5", ["E4", "D5"]),          //17
        "B6": Edge("B6", ["B4", "D6"]),          //18
        "D6": Edge("D6", ["D5", "B6", "F6", "D7"]),  //19
        "F6": Edge("F6", ["F4", "D6"]),          //20
        "A7": Edge("A7", ["A4", "D7"]),           //21
        "D7": Edge("D7", ["D6", "A7", "G7"]),      //22
        "G7": Edge("G7", ["G4", "D7"]),          //23
    ]

    public func printBoard() {
        edges["A1"].?.neighbours.find
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

    public func isFieldEmpty(position:String){
        if let edge = self.edges[position]{
            return edge.isEmpty
        }

        return false
    }
}