import PlayerLibrary

protocol Edge {
    var position: String {get set}
    var neighbours: [String] {get set}
    var isEmpty: Bool {get set}
    var chip: PlayerChip? {get set}

    func edgeToString() -> String
    func setPlayer(chip:PlayerChip?) -> Void
    func removePlayer(chip:PlayerChip?) -> Void
}

public class BoardEdge: Edge {
    public var neighbours: [String] = []
    var position: String
    public var isEmpty = true
    public var chip: PlayerChip?

    public init(_ position: String,_ neighbours: [String]){
        self.neighbours = neighbours
        self.position = position
    }

    init(position: String){
        self.position = position
    }

    public func setPlayer(chip:PlayerChip?){
        self.chip = chip
        self.isEmpty = false
    }

    public func removePlayer(chip:PlayerChip?){
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
    func printBoard() -> Void
}

public class GameBoard: Board {
    // each edge has a neighbours. In this array they are mapped as edge index -> neighbours
    // edge with index 0 will be the top right corner, edge with index one will be the second edge on the first row, etc.
    public let edges:[String:BoardEdge] = [
        "A1": BoardEdge("A1", ["D1", "A4"]),            //0
        "D1": BoardEdge("D1", ["A1", "G1", "D2"]),         //1
        "G1": BoardEdge("G1", ["D1", "G4"]),           //2
        "B2": BoardEdge("B2", ["D2", "B4"]),           //3
        "D2": BoardEdge("D2", ["D1", "B2", "F2", "D3"]),      //4
        "F2": BoardEdge("F2", ["D2", "F4"]),           //5
        "C3": BoardEdge("C3", ["D3", "C4"]),           //6
        "D3": BoardEdge("D3", ["D2", "C3", "F3"]),         //7
        "F3": BoardEdge("F3", ["D3", "E4"]),           //8
        "A4": BoardEdge("A4", ["A1", "B4", "A7"]),       //9
        "B4": BoardEdge("B4", ["B2", "A4", "C4", "B6"]),    //10
        "C4": BoardEdge("C4", ["C3", "B4", "C5"]),       //11
        "E4": BoardEdge("E4", ["F3", "F4", "E5"]),       //12
        "F4": BoardEdge("F4", ["F2", "E4", "G4", "F6"]),   //13
        "G4": BoardEdge("G4", ["G1", "F4", "G7"]),       //14
        "C5": BoardEdge("C5", ["C4", "D5"]),          //15
        "D5": BoardEdge("D5", ["C5", "E5", "D6"]),      //16
        "E5": BoardEdge("E5", ["E4", "D5"]),          //17
        "B6": BoardEdge("B6", ["B4", "D6"]),          //18
        "D6": BoardEdge("D6", ["D5", "B6", "F6", "D7"]),  //19
        "F6": BoardEdge("F6", ["F4", "D6"]),          //20
        "A7": BoardEdge("A7", ["A4", "D7"]),           //21
        "D7": BoardEdge("D7", ["D6", "A7", "G7"]),      //22
        "G7": BoardEdge("G7", ["G4", "D7"]),          //23
    ]

    public let tripplesX = [["A1","D1","G1"], ["B2", "D2", "F2"], ["C3", "D3", "F3"],  ["A4","B4","C4"],
                     ["E4","F4","G4"], ["C5","D5","E5"], ["B6","D6","F6"], ["A7", "D7","G7"]]

    public let tripplesY = [["A1","A4","A7"], ["B2","B4","B6"],["C3","C4","C5"],["D1","D2","D3"],
                     ["D5","D6","D7"], ["E3","E4","E5"], ["F2","F4","F6"],["G1","G4","G7"]]

    public init(){

    }

    public func printBoard() {
        print("\(edges["A1"]!.edgeToString())---------\(edges["D1"]!.edgeToString())---------\(edges["G1"]!.edgeToString())")
        print("|         |         |")
        print("|  \(edges["B2"]!.edgeToString())------\(edges["D2"]!.edgeToString())------\(edges["F2"]!.edgeToString())  |")
        print("|  |      |      |  |")
        print("|  |   \(edges["C3"]!.edgeToString())--\(edges["D3"]!.edgeToString())--\(edges["F3"]!.edgeToString())   |  |")
        print("|  |   |     |   |  |")
        print("\(edges["A4"]!.edgeToString())--\(edges["B4"]!.edgeToString())---\(edges["C4"]!.edgeToString())     \(edges["E4"]!.edgeToString())---\(edges["F4"]!.edgeToString())--\(edges["G4"]!.edgeToString())")
        print("|  |   |     |   |  |")
        print("|  |   \(edges["C5"]!.edgeToString())--\(edges["D5"]!.edgeToString())--\(edges["E5"]!.edgeToString())   |  |")
        print("|  |      |      |  |")
        print("|  \(edges["B6"]!.edgeToString())------\(edges["D6"]!.edgeToString())------\(edges["F6"]!.edgeToString())  |")
        print("|         |         |")
        print("\(edges["A7"]!.edgeToString())---------\(edges["D7"]!.edgeToString())---------\(edges["G7"]!.edgeToString())")
    }

    public func isFieldEmpty(position:String) -> Bool{
        if let edge = self.edges[position]{
            return edge.isEmpty
        }

        return false
    }
}