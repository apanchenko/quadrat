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
cfg.board         = {vx=0, vy=15, vw=100, cols=7, rows=7}

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

cfg.abilities =
{
  vx = 9,
  y = (cfg.vh * cfg.board.vy) + (cfg.vw * cfg.board.vw) + cfg.vh,
  button =
  {
    x = 0,
    y = 0,
    vw = 40,
    height = 16,
    emboss = false,
    font = cfg.font,
    fontSize = 14,
    shape = "roundedRect",
    cornerRadius = 3,
    fillColor   = { default = {0.3, 0.4, 0.5, 1.0}, over = {0.6, 0.7, 0.8, 0.8} },
    labelColor  = { default = {1.0, 1.0, 1.0, 1.0}, over = {1.0, 1.0, 1.0, 1.0} },
    strokeColor = { default = {0.3, 0.4, 0.5, 0.5}, over = {0.8, 0.8, 1.0, 1.0} },
    strokeWidth = 1
  },
  rows =
  {
    length = 2,
    space_px = 2,
    space_py = 1
  }
}

return cfg