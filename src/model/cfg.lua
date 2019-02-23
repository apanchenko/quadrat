local vec = require 'src.core.vec'

local cfg = {}

-- screen dimensions
cfg.vw            = display.contentWidth / 100
cfg.vh            = display.contentHeight / 100
cfg.font          = native.systemFont

cfg.origin        = {vx=0, vy=0}
cfg.battle        = {}
cfg.battle.bg     = {vx=0, vy=0, vw=100, vh=100, path="src/background.png"}
cfg.battle.arrow  = {vx=4, vy=4, vw=12, ratio=2, path="src/view/arrow.png"}
cfg.cell          = {vx=0, vy=0, w=64, h=64, size=vec(64, 64)}
cfg.board         = {vx=0, vy=15, vw=100, cols=8, rows=8}

cfg.player =
{
  vx = 0,
  vy = 0,
  vw = 6,
  ratio = 1,
  red             = {vx=18, vy=4},
  black           = {vx=18, vy=9}
}

cfg.jade =
{
  vx = 0, vy = 0,
  w                 = cfg.cell.w,
  h                 = cfg.cell.h,
  path              = "src/view/jade.png", 
  moves             = 2,    -- drop jades every Nth move
  probability       = 0.1   -- probability that a jade will spawn on a cell
}

cfg.stone         =
{
  move =
  {
    time=500,
    transition=easing.inOutQuad
  }
}

cfg.abilities     = {vx = 5,
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