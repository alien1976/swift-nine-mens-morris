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

    This game requires exactly 2 players.
    This game has been developed as a terminal app using swift language.
    To play the game you need to follow the following rules:
        * Each player has one turn after the other one
        * Each player has nine chips at the beginning of the game
        * There are two phases of the game:
            * First phase: 
                - Each player needs to set its chips on all the available positions on the board.
                - If a player form mill during this stage of the game he/she needs to remove an opponent chip from the board.
            * Second phase: 
                - When all the chips are placed onto the board then the players need to start moving their chips around the available position on the board
                - A chip can be moved to any available(empty) position that is a neighbor to the selected chip position.
                - When players move its chip and form a mill then he/she need to remove an opponent chip from the board.
                - If some player left with just three or fewer chips on the board then he/she can move any chip anywhere on the available board positions.
        * To set a chip on the board you need to type the chip coordinates on the console using the following syntax:
          > Player1, Set chip: A1
        * To move chip on the board you need to type the chip coordinates that will be moved concatenated with the destination coordinates like this:
          > Player1, Move chip: A1A4
        * If a mill formed from player he/she needs to remove an opponent chip with the following syntax command:
          > Player1 has set three chips in one line. Remove opponent chip with color o: A1
    For more info about the game and rules, you can check https://en.wikipedia.org/wiki/Nine_men%27s_morris
    Press enter to continue...
    """

    var gamePhase = GamePhase.ADD
    var millFormed = false
    var gamePaused = true
    let greetingString = "Hello to nine-mens-morris game!"

    func start(){
        print("\(self.greetingString)\n\n\(self.helpString)")
        commandsReader(gamePhase: firstGamePhaseCommands)
        if gameFinished() {
            return
        }
        commandsReader(gamePhase: secondGamePhaseCommands)
    }

    func commandsReader(gamePhase: (_ command:String)-> Bool){
        while let input = readLine() {
            guard input != "exit" else {
                print("Exiting game...")
                exit(0)
                break
            }

            guard input != "help" else {
                self.gamePaused = true
                clearAndPrintOutput(additionalOutput: self.helpString)
                continue
            }

            if self.gamePaused && input == "" {
                self.gamePaused = false
                if (!finishTurn(shouldChangePlayer: false){
                    return self.gameController.activePlayer.playerName + (self.gamePhase == GamePhase.MOVE ? ", Move chip:" : ", Set chip:")
                    }) {return}
                continue
            }

            if self.millFormed {
                let removeChipRes = self.gameController.removeopponentChipOn(position: input)

                if removeChipRes != "" {
                    if (!finishTurn(shouldChangePlayer: false){
                        "\(removeChipRes)\n\(self.gameController.activePlayer.playerName) has set three chips in one line. Remove opponent chip with color \(self.gameController.notActivePlayer.color.rawValue)! "
                        }) {return}
                    continue
                }

                self.millFormed = false

                if !(finishTurn{
                    return self.gameController.activePlayer.playerName + (self.gamePhase == GamePhase.MOVE ? ", Move chip:" : ", Set chip:")
                }){return}
                continue
            }

            if !gamePhase(input) {
                return
            }
        }
    }

    func firstGamePhaseCommands(command:String) -> Bool{
        //will set chip on position with parsing and validating the position
        let parseRes = parse(command: command)

        if parseRes != "" {
            return finishTurn(shouldChangePlayer: false) {
                "\(parseRes)\n"+self.gameController.activePlayer.playerName + ", Move chip:"
            } 
        }

        self.gameController.decreaseActivePlayerChips()

        if self.gameController.isMillFormed(position: command, color: self.gameController.activePlayer.color){
            self.millFormed = true

            return finishTurn(shouldChangePlayer: false){
                "\(self.gameController.activePlayer.playerName) has set three chips in one line. Remove opponent chip with color \(self.gameController.notActivePlayer.color.rawValue): "
            }
        }

        return finishTurn {
            self.gameController.activePlayer.playerName + ", Set chip:"
        }
    }

    func secondGamePhaseCommands(command:String) -> Bool{
        //will set chip on position with parsing and validating the position
        let parseRes = parse(command: command)

        if parseRes != "" {
            return finishTurn(shouldChangePlayer: false) {
                "\(parseRes)\n"+self.gameController.activePlayer.playerName + ", Move chip:"
            } 
        }

        let to =  String(command.suffix(2))

        if self.gameController.isMillFormed(position: to, color: self.gameController.activePlayer.color){
            self.millFormed = true

            return finishTurn(shouldChangePlayer: false){
                "\(self.gameController.activePlayer.playerName) has set three chips in one line. Remove opponent chip with color \(self.gameController.notActivePlayer.color.rawValue): "
            }
        }

        return finishTurn {
            self.gameController.activePlayer.playerName + ", Move chip:"
        }
    }

    func finishTurn(shouldChangePlayer:Bool = true, infoMessage: () -> String = {""}) -> Bool{
        if shouldChangePlayer {self.gameController.changeActivePlayer()}

        if self.gamePhase == GamePhase.ADD && self.gameController.areAllChipsSet()  {
            self.gamePhase = GamePhase.MOVE
            clearAndPrintOutput(additionalOutput: infoMessage())

            return false
        }

        clearAndPrintOutput(additionalOutput: infoMessage())

        if self.gamePhase == GamePhase.MOVE && gameFinished() {
            return false
        }

        return true
    }

    func gameFinished()->Bool{
        if self.gameController.isGameLostFrom(player: self.gameController.activePlayer) {
            print("Game finished! Winner: \(self.gameController.notActivePlayer.playerName)")
            return true
        }

        if self.gameController.isGameEqual() {
            print("Game finished! There are no winner - Both players don't have available positions to move their chips!")
            return true
        }

        return false
    }

    func parse(command: String) -> String{
        switch self.gamePhase{
        case .ADD:
            return parsePhaseOne(command: command)
        case .MOVE:
            return parsePhaseTwoCommand(command: command)
        }
    }

    func parsePhaseOne(command: String) -> String{
        if !self.gameController.isValid(position:command){
            return "Warning: Invalid position \(command) passed!"
        }

        if !self.gameController.setChipOn(position:command){
            return "Warning: Unable to set chip on position \(command). The field is not empty!"
        }

        return ""
    }

    func parsePhaseTwoCommand(command: String) -> String{
        if command.count != 4 {return "Warning: Command must be exact 4 characters like 'A1A4'!"}
        let from = String(command.prefix(2))
        let to =  String(command.suffix(2))

        if !self.gameController.isValid(position:from){
            return "Warning: The position \(from) is not valid"
        }

        if !self.gameController.isValid(position:to){
            return "Warning: The position \(to) is not valid"
        }

        return self.gameController.moveChip(from: from, to: to, fly: self.gameController.activePlayer.playerChipsOnBoard == 3)
    }

    func clearAndPrintOutput(additionalOutput:String  = ""){
        system("clear")
        self.gameController.printBoard()
        print("""
            \nGame info: \(self.gamePhase == GamePhase.ADD ? "Phase 1 (add chips on the board)": "Phase 2 (move chips on the board)").
            Player1 chips on board: \(self.gameController.getPlayerChipsCount("Player1"))
            Player2 chips on board: \(self.gameController.getPlayerChipsCount("Player2"))
            \(additionalOutput)
            """)
    }
}