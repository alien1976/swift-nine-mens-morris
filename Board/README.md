# Board Library

This library can be used to instantiate a board of nine mens morris game.
It includes the classes for GameBoard, BoardEdge and PlayerChip.

* Instantiating GameBoard will create a new nine mens morris board that can be printed and changed if any of its edges are changed
* Instantiating BoardEdge will create a new edge where the player can set any chip on it by changing the chip class member.
* PlayerChip is used to create a new chip that the player can use for setting it on the board or moving it on any available board position
    * The state of the PlayerChip inside this library contains just the default chip color. It can be extended from any module that depend on this library with the needs of developer.