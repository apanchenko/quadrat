local Pos = require("src.core.Pos")

local Config =
{
  -- screen dimensions
  vw = display.contentWidth / 100,
  vh = display.contentHeight / 100,

  -- default font
  font = native.systemFont,

  -- width and height of the board in cells
  board_size = Pos(3, 3),

  -- width and height of cell in pixels
  cell_size = Pos(64, 64),

  -- drop jades every Nth move
  jade_moves = 3,

  -- probability that a jade will spawn on a cell
  jade_probability = 0.1,
}

return Config