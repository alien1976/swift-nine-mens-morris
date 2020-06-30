import ControllerLibrary
import Glibc

class Game{
    // var gameController:Controller = Controller()
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
    Press any key and then enter to start the game...
    """

    let greetingString = "Hello to nine-mens-morris game!"

    func start(){
        print("\(self.greetingString)\n\n\(self.helpString)")
        system("clear")
        // print("\u{001B}[2J")
        print("Game has started")
    }

    func readCommand(){

    }
}