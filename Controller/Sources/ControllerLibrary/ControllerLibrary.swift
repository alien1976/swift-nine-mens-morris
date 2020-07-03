import BoardLibrary
import PlayerLibrary

protocol Controller{
    var Player1: Player {get}
    var Player2: Player {get}
    var Board: GameBoard {get}
}

public class GameController {
    var Player1: Player = Player("Player1",Color.filled)
    var Player2: Player = Player("Player2",Color.empty)
    var Board: GameBoard = GameBoard()
    public var activePlayer: Player
    public var notActivePlayer: Player

    public init(){
        self.activePlayer = self.Player1
        self.notActivePlayer = self.Player2
    }

    public func changeActivePlayer(){
        let tempPlayer = activePlayer;
        self.activePlayer = self.notActivePlayer
        self.notActivePlayer = tempPlayer
    }

    public func setChipOn(position: String)->Bool{
        if !self.Board.isFieldEmpty(position: position) {
            print("Warning: This position is not empty! Please try with another one!")
            return false
        }

        let newChip = PlayerChip(position, self.activePlayer.color)
        if let edge = self.Board.edges[position] {
            edge.setPlayer(chip: newChip)
            self.activePlayer.addChip(chip: newChip)
            return true
        }

        return false
    }

    func moveChip(from:String, to: String, fly:Bool = false){
        guard let edge = self.Board.edges[from] else {
            print("Warning: From position \(from) is invalid!")
            return
        }

        guard let edgeChip = edge.chip else {
            print("Warning: There is no chip for moving on position - \(from)!")
            return
        }

        guard let destEdge = self.Board.edges[to] else {
            print("Warning: To position \(from) is invalid!")
            return
        }

        if !fly && !destEdge.neighbours.contains(to){
            print("Warning: From position \(from) does not have destination position as a neighbour!")
            return
        }

        if !destEdge.isEmpty {
            print("Warning: To position \(from) is not empty!")
            return
        }

        destEdge.setPlayer(chip: edgeChip)
        edge.removePlayer(chip: edgeChip)
        self.activePlayer.moveChip(from: from, to: to)
    }

    public func removeOponentChipOn(position:String)->Bool{
        guard let edge = self.Board.edges[position] else {
            print("Warning: Oponent chip position \(position) is invalid!")
            return false
        }

        guard let edgeChip = edge.chip else {
            print("Warning: There is no oponent chip on position - \(position)!")
            return false
        }

        if (edgeChip.color == activePlayer.color) {
            print("Warning: You can't remove your own chip!")
            return false
        }

        if !isRemoveOponentChipValid(position: position) {
            print("Warning: You can't remove oponent chip that is a part of a formed mill")
            return false
        }

        edge.removePlayer(chip: edgeChip)
        self.notActivePlayer.removeChip(position: edgeChip.position)
        return true;
    }

    public func isRemoveOponentChipValid(position: String) -> Bool{
        //checks if there chips that are not forming mill on the oponent player side
        //if there are none then the active player can remove a chip that form a mill
        if(!isNotMillFormed(playerChips: self.notActivePlayer.chips, color: self.notActivePlayer.color) ){
            return true
        }

        if (isMillFormed(position: position,color: self.notActivePlayer.color)) {
            return false
        }

        return true
    }

    public func isNotMillFormed(playerChips: [PlayerChip], color: Color) -> Bool{
        for chip in playerChips {
            if (!isMillFormed(position: chip.position, color: color)) {
                return true
            }
        }

        return false
    }

    public func isMillFormed(position: String, color: Color) -> Bool{
        guard let edge = self.Board.edges[position] else {
            return false
        }

        if isMillIn(tripples: edge.edgeLineNeighbours, color: color) {
            return true
        }

        return false
    }

    func isMillIn(tripples: [[String]], color: Color) -> Bool{
        for tripple in tripples {
            if(isTrippleMillFormed(tripple: tripple){
                $0.rawValue == color.rawValue
            }){
                return true
            }
        }

        return false
    }

    func isTrippleMillNotFormed(tripple: [String], isColorSame: (Color)->Bool) -> Bool{
        for edgePosition in tripple {
            guard let edge = self.Board.edges[edgePosition] else {
                continue
            }

            guard let chip = edge.chip else{
                continue
            }

            if isColorSame(chip.color) && !isMillIn(tripples: edge.edgeLineNeighbours, color: chip.color) {
                return true
            }
        }

        return false
    }

    func isTrippleMillFormed(tripple: [String], isColorSame: (Color)->Bool) -> Bool{
        for edgePosition in tripple {
            guard let edge = self.Board.edges[edgePosition] else {
                return false
            }

            guard let chip = edge.chip else{
                return false
            }

            if !isColorSame(chip.color) {return false}
        }

        return true
    }

    public func printBoard(){
        self.Board.printBoard()
    }

    public func getPlayerChipsCount(_ playerName:String)->Int{
        switch playerName{
        case self.Player1.playerName:
            return self.Player1.playerChipsOnBoard
        case self.Player2.playerName:
            return self.Player2.playerChipsOnBoard
        default:
            return 0
        }
    }

    public func isValid(position: String)->Bool{
        return self.Board.isValid(position:position)
    }

    public func decreaseActivePlayerChips(){
        self.activePlayer.startGameChips -= 1
    }

    public func areAllChipsSet() -> Bool {
        return self.Player1.startGameChips <= 0 && self.Player2.startGameChips <= 0
    }
}