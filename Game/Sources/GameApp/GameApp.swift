import ControllerLibrary
import Glibc

enum GamePhase {
    case ADD
    case MOVE
}

class Game{
    var gameController:GameController = GameController()
    let helpString = """
    Some useful commands:
    * help - Will display this message with useful commands and game rules
    * exit - Will exit the game

    This game requires exact 2 players.
    This game has been developed as a terminal app using swift language.
    To play the game you need to follow the following rules:
        * Each player has one turn after the other one
        * Each player has nine chips at the begining of the game
        * There are two phases of the game:
            * First phase: 
                - Each player need to set its chips on all the available positions on the board.
                - If player form mill during this stage of the game he/she need to remove an oponent chip from the board.
            * Second phase: 
                - When all the chips are place onto the board then the players need to start moving their chips around available position on the board
                - Chip can be moved to any available(empty) position that is a neghbour to the selected chip position.
                - When a player move its chip and form a mill then he/she need to remove an oponent chip from the board.
                - If some player left with just three or less chips on the board then he/she can move any chip anywhere on the available board positions.
        * To set chip on the board you need to type the chip coordinates on the console using the following syntax:
          > Player1, Set chip: A1
        * To move chip pn the board you need to type the chip coordinates that will be moved concatenated with the destination coordinates like this:
          > Player1, Move chip: A1A4
        * If a mill formed from player he/she needs to remove an oponent chip with the following syntax command:
          > Player1, Remove oponent chip: A1
    For more info about the game and rules you can check https://en.wikipedia.org/wiki/Nine_men%27s_morris
    Press enter to continue...
    """

    var gamePhase = GamePhase.ADD
    var millFormed = false
    var gamePaused = true
    let greetingString = "Hello to nine-mens-morris game!"

    func start(){
        print("\(self.greetingString)\n\n\(self.helpString)")
        commandsReader(gamePhase: firstGamePhaseCommands)
    }

    func commandsReader(gamePhase: (_ command:String)-> Bool){
        while let input = readLine() {
            guard input != "exit" else {
                print("Game has ended")
                break
            }

            guard input != "help" else {
                self.gamePaused = true
                clearAndPrintOutput {
                    self.helpString
                }
                continue
            }

            if !gamePhase(input) {
                return
            }
        }
    }

    func firstGamePhaseCommands(command:String) -> Bool{
        if self.gamePaused && command == "" {
            self.gamePaused = false
            return finishPhaseTurn(shouldChangePlayer: false){
                return self.gameController.activePlayer.playerName + ", Set chip:"
            }
        }

        if self.millFormed && self.gameController.removeOponentChipOn(position: command){
            self.millFormed = false
            return finishPhaseTurn{
                self.gameController.activePlayer.playerName + ", Set chip:"
            }
        } else if self.millFormed {
            return finishPhaseTurn(shouldChangePlayer: false){
                "You've set three chips in one line. Remove oponent chip! "
            }
        }

        //will set chip on position with parsing and validating the position
        if !parse(command:command){
            return finishPhaseTurn(shouldChangePlayer: false){
                "Unable to set chip on \(command)\n"+self.gameController.activePlayer.playerName + ", Set chip:"
            }
        }

        self.gameController.decreaseActivePlayerChips()

        if self.gameController.isMillFormed(position: command, color: self.gameController.activePlayer.color){
            self.millFormed = true

            return finishPhaseTurn(shouldChangePlayer: false){
                "You've set three chips in one line. Remove oponent chip: "
            }
        }

        return finishPhaseTurn {
            self.gameController.activePlayer.playerName + ", Set chip:"
        }
    }

    func finishPhaseTurn(shouldChangePlayer:Bool = true, infoMessage: () -> String = {""}) ->Bool{
        if shouldChangePlayer {self.gameController.changeActivePlayer()}

        if self.gameController.areAllChipsSet() {
            clearAndPrintOutput{
                infoMessage()
            }
            return false
        }

        clearAndPrintOutput{
            infoMessage()
        }

        return true
    }

    func parse(command: String)->Bool{
        switch self.gamePhase{
        case .ADD:
            return parsePhaseOne(command: command)
            // case .MOVE:
            //     parsePhaseTwoCommand(command)
        case .MOVE:
            return false
        }
    }

    func parsePhaseOne(command: String) -> Bool{
        if !self.gameController.isValid(position:command){
            return false
        }

        if !self.gameController.setChipOn(position:command){
            return false
        }

        return true
    }

    func clearAndPrintOutput(additionalOutput:()->String = {""}){
        system("clear")
        self.gameController.printBoard()
        print("""
            \nGame info: Phase 1 (add chips on the board).
            Player1 chips on board: \(self.gameController.getPlayerChipsCount("Player1"))
            Player2 chips on board: \(self.gameController.getPlayerChipsCount("Player2"))
            \(additionalOutput())
            """)
    }
}