local Pos = require("src.Pos")

local Config =
{
  -- width and height of the board in cells
  board_size = Pos(8, 8),

  -- width and height of cell in pixels
  cell_size = Pos(64, 64),

  -- drop jades every Nth move
  jade_moves = 3,

  -- probability that a jade will spawn on a cell
  jade_probability = 0.1,
}

return Config