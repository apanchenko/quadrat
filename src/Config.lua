local Pos = require("src.core.Pos")

local cfg = {}

-- screen dimensions
cfg.vw = display.contentWidth / 100
cfg.vh = display.contentHeight / 100

-- default font
cfg.font = native.systemFont

-- width and height of the board in cells
cfg.board_size = Pos(5, 5)

-- jade options
cfg.jade =
{
  moves = 1,          -- drop jades every Nth move
  probability = 0.2   -- probability that a jade will spawn on a cell
}

-- board options
cfg.board =
{
  vx = 5,
  vw = 90,
  vy = 15
}

cfg.cell =
{
  w = 64,
  h = 64,
  size = Pos(64, 64)
}

cfg.abilities =
{
  vx = 5,
  button =
  {
    emboss = false,
    font = cfg.font,
    fontSize = 17,
    width = 250,
    height = 32,
    shape = "roundedRect",
    cornerRadius = 9,
    fillColor   = { default = {0.6, 0.7, 0.8, 1}, over = {0.6, 0.7, 0.8, 0.8} },
    labelColor  = { default = {1.0, 1.0, 1.0, 1}, over = {1.0, 1.0, 1.0, 1.0} },
    strokeColor = { default = {1.0, 0.4, 0.0, 1}, over = {0.8, 0.8, 1.0, 1.0} },
    strokeWidth = 1
  }
}
cfg.abilities.y = (cfg.vh * cfg.board.vy) + (cfg.vw * cfg.board.vw) + cfg.vh


return cfg