# Quadrat design

## Thesaurus

- quadrat - the name of the game
- field   - one of 64 square element of the board
- jade    - randomly spawns on free fields, contains an ability or modification

## Keywords

chekers, board, powerups, quadradius

## Short description

Checkers with powerups.

## Core game description

The Quadrat is an 8x8 squares board game for two players. Each player starts with 16 similar stones placed on first two lines like in chess.
Each turn a player may

1. use any amount of jades her stones have
2. then move any stone one square in any straight direction to:
   - either an empty field
   - or field with jade, acquiring it
   - or field is taken by opponent stone, killing it.

As a game goes on new jades will spawn on free fields. Players normally cannot see spawned jades qualities. When a jade is acquired, depending on its type, it:

- immediately modifies owner stone
- or stored in owner stone to be used later.

A player must destroy all enemy stones to win. The easiest way to destroy an enemy stone is to move your stone on top it.

Yet basic rules are primitive and accessible to everyone, to become proficient it is crucial to have a good knowledge of jade abilities, how they interact and how to organize better collaboration in certain context.

### todo - fix stone-jade - similar meaning

## Meta game description

Player starts first battle with a set of free jades. Every time she eats a new jade, the jade becomes available immediately or in jade shop.
A player has a box of selected jades to be used in battle.

## Jades

- may be Radial, Row or Column

| Name            | Effect                                     | Free         |
|----------------:|-------------------------------------------:|-------------:|
| Multiply        | Creates a new piece. Can be placed anywhere adjacent to the piece that used the ability.                                   | No           |
| Jade Rehash     | Removes all current Power Orbs and randomly places new ones onto the board.                                                | No           |
| Grow Quadradius | Extends the range for any move the piece uses that effects either a row, column, or radial. Row and column power ups will now affect all three rows or columns around the piece, and radial power ups will affect any space that is at most 2 spaces away. The range can be extended further with another Grow Quadradius power up.                              | No           |
| Bombs           | Randomly blows up squares on the board. Kills any piece that is hit, and pushes the square downwards.                  | No           |
| Snake Tunneling | Energy tunnels under the board, randomly seeking out opponents. This raises tiles and destroys any enemies that might be hit. Snake Tunneling moves randomly, and can backtrack its path.          | No           |
| Raise Field     | Raises the tile that the piece using the ability is currently on.                                                  | No           |
| Lower Field     | Lowers the tile that the piece using the ability is currently on.                                                  | No           |
| Climb Field     | The piece is able to move up any tile no matter how high it is.                                                            | No           |
| Plateau         | Raises every tile within a radial of your piece.                                                                           | No           |
| Moat            | Lowers every tile next to your piece.      | No           |
| Trench RC       | Lowers every tile in the same row as your piece.                                                                           | No           |
| Wall RC         | Raises every tile in the same row as your piece.                                                                           | No           |
| Invert *        | All surrounding tiles have their elevations inverted.                                                                      | No           |
| Dredge *        | All of your surrounding pieces are raised to their max height while your opponent's are lowered to their deepest.     | Yes          |
| Teach *         | All allied pieces in the same radial as your piece will learn all of the abilities your piece currently has.           | No           |
| Learn *         | Your piece learns all abilities your surrounding pieces have.                                                          | No           |
| Pilfer *        | Steal all powers from the opponents surrounding you.                                                                       | No           |
| Parasite *      | Leeches onto any surrounding enemy pieces. Any new powers they acquire your piece will also acquire.                     | No           |
| 2x              | Doubles the amount of powers your piece currently possesses.                                                     | No           |
| Beneficiary     | All of your pieces give away their powers and put them onto this one piece.                                                | No           |
| Scavenger       | If a scavenger piece jumps on an enemy piece, all of your scavenger pieces will receive that enemy piece's abilities.    | Yes          |
| Power Plant     | Steals any orbs that spawn on the tile, and shares them with any piece on your aligned power plant grid.               | Yes          |
| Network Bridge  | This piece will tap into all the networked powers activated by others in your squadron. Any power that is normally absorbed through the squadron-wide network, is now absorbed by this piece also.     | Yes          |
| Move Again      | This piece can move twice in this one turn.| No           |
| Move Diagonal   | This piece can permanently move diagonally.| No           |
| Flat to Sphere  | This piece can now move off the map, and will appear on the opposite side.                                                 | No           |
| Relocate        | Teleports this piece to a random unoccupied location on the board.                                                         | No           |
| Hotspot         | Any of your pieces can now permanently move to this tile, no matter where they are, as long as one of your pieces isn't already on the tile.                                                          | No           |
| Switcheroo      | You can switch this piece with any other allied piece.                                                                     | Yes          |
| Centerpult      | Your piece can catapult itself into the vacant center of any four, symmetric pieces, as long as occupying the empty, center tile will complete either a plus sign or an 'x' shaped pattern.          | Yes          |
| Invisible       | Your opponent can no longer see your piece. It can still be destroyed, however.                                            | Yes          |
| Jump Proof      | This piece can no longer be defeated by being jump on by an enemy piece.                                                   | No           |
| Scramble *      | Randomly moves around every piece in the same radial as yours.                                                         | No           |
| Swap *          | Your piece and all surrounding pieces swap ownership with your opponent.                                                 | No           |
| Spyware *       | You can see any powers that the opponent's surrounding pieces have. This stays permanently on the pieces, letting you see new powers they acquire as well.                                          | No           |
| Orb Spy *       | Bugs every tile surrounding your piece. You can view the power of any orb that spawns on these tiles.                   | Yes          |
| Refurb *        | Resets every tile surrounding your piece.  | Yes          |
| Bankrupt *      | Resets every enemy piece that comes into contact with a tile in this radial.                                           | Yes          |
| Purify *        | Removes any disabilities on your pieces, and removes any benefits your opponent's pieces have as well.                                                                   | No           |
| Tripwire *      | If any enemy piece within the same radial as your piece moves off of its tile, it will be destroyed.                   | No           |
| Inhibit *       | Your opponent's pieces in the same radial as your piece can no longer acquire power ups from Power Orbs.                   | No           |
| Kamikaze *      | Destroys all pieces in the same radial as your piece, including the piece activating the ability, and any of your pieces within range.                                                         | No           |
| Destroy *       | Destroys any surrounding enemy pieces.     | No           |
| Acidic *        | Destroys any surrounding enemy pieces. Their tiles become completely uninhabitable.                                      | No           |
| Recruit *       | Steal any enemy pieces surrounding your piece.                                                                             | No           |

## Quadradius reference

- [Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=187949734)
- [fb](https://www.facebook.com/Quadradius/)
