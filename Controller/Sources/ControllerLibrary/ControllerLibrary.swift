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
    var activePlayer: Player
    var notActivePlayer: Player

    public init(){
        self.activePlayer = self.Player1
        self.notActivePlayer = self.Player2
    }

    func changeActivePlayer(){
        let tempPlayer = activePlayer;
        self.activePlayer = self.notActivePlayer
        self.notActivePlayer = tempPlayer
    }

    func setChipOn(position: String){
        if !self.Board.isFieldEmpty(position: position) {
            print("Warning: This position is not empty! Please try with another one!")
            return
        }

        let newChip = PlayerChip(position, self.activePlayer.color)

        if let edge = self.Board.edges[position] {
            edge.setPlayer(chip: newChip)
            self.activePlayer.increaseChipsCount()
        }
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
    }

    func removeOponentChipOn(position:String){
        guard let edge = self.Board.edges[position] else {
            print("Warning: Oponent chip position \(position) is invalid!")
            return
        }

        guard let edgeChip = edge.chip else {
            print("Warning: There is no on position - \(position)!")
            return
        }

        if (edgeChip.color == activePlayer.color) {
            print("Warning: You can't remove your own chip!")
            return
        }

        edge.removePlayer(chip: edgeChip)
        self.notActivePlayer.decreaseChipsCount()
    }

    func isMillFormed() -> Bool{
        if isMillIn(tripples: self.Board.tripplesX) {
            return true
        }

        if isMillIn(tripples: self.Board.tripplesY) {
            return true
        }

        return false
    }

    func isMillIn(tripples: [[String]]) -> Bool{
        for tripple in tripples {
            if(isTrippleMillFormed(tripple: tripple){
                $0 != self.activePlayer.color
            }){
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
}