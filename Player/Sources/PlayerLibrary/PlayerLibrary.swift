public enum Color: String {
    case empty = "o"
    case filled = "●"
    case none = ""

    public func getColorFromString(color:String) -> Color {
        switch color {
        case Color.empty.rawValue: return Color.empty
        case Color.filled.rawValue: return Color.filled
        default: return Color.none
        }
    }

    public func toString() -> String {
        return self.rawValue
    }
}

public struct PlayerChip {
    public var position: String
    public var color: Color = Color.none

    init(position: String){
        self.position = position
    }

    public init(_ position: String,_ color: Color){
        self.position = position
        self.color = color
    }

    mutating func setColor(color: Color){
        self.color = color
    }
}

protocol PlayerData {
    var chips: [PlayerChip] {get set}
    var color: Color {get set}
    var playerChipsOnBoard: Int {get set}
    var playerName:String {get set}
}

public class Player: PlayerData {
    public var chips: [PlayerChip] = []
    public var playerChipsOnBoard = 0
    public var color: Color = Color.none
    public var playerName:String
    public var startGameChips = 9

    init(playerName: String){
        self.playerName = playerName
    }

    public init(_ playerName: String,_ color: Color){
        self.playerName = playerName
        self.color = color
    }

    public func setPlayerColor(color:String){
        let colorEnum = Color(rawValue: color)

        switch colorEnum {
        case nil: 
            self.color = Color.none
            print("Warning: Setting \(color) to \(self.playerName) was not successful. Selecting default color instead!")
        default: self.color = colorEnum!
        }
    }

    public func setPlayerColor(color:Color){
        self.color = color
    }

    public func addChip(chip: PlayerChip){
        if (self.chips.contains{currentChip in currentChip.position == chip.position}) {
            print("Warning: Won't add chip with position \(chip.position) because already exists")
        }

        self.chips.append(chip)
        increaseChipsCount()
    }

    public func increaseChipsCount(){
        self.playerChipsOnBoard += 1
    }

    public func decreaseChipsCount(){
        self.playerChipsOnBoard -= 1
    }

    public func removeChip(position: String)->String{
        guard let chipIndex = (self.chips.firstIndex{currentChip in currentChip.position == position}) else {
            return "Warning: Chip with position \(position) does not exists in \(self.playerName)'s chips!"
        }

        self.chips.remove(at: chipIndex)
        decreaseChipsCount()

        return ""
    }

    public func moveChip(from: String, to: String) -> String {
        guard let chipIndex = (self.chips.firstIndex{currentChip in currentChip.position == from}) else {
            return "Warning: Chip with position \(from) does not exists in \(self.playerName)'s chips!"
        }

        self.chips[chipIndex].position = to
        return ""
    }
}