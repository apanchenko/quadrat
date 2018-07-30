local Pos = require("src.Pos")

local Config =
{
  -- width and height of the board in cells
  board_size = Pos(5, 5),

  -- size of the cell in pixel
  cell_size = Pos(64, 64),

  -- drop jades every Nth move
  jade_moves = 2,

  -- probability that a jade will spawn on a cell
  jade_probability = 0.1,
}

return Config