local vec = require("src.core.Vec")

local cfg = {}

-- screen dimensions
cfg.vw            = display.contentWidth / 100
cfg.vh            = display.contentHeight / 100
cfg.font          = native.systemFont

cfg.battle        = {}
cfg.battle.bg     = {vw=100, vh=100, path="src/background.png"}
cfg.battle.arrow  = {vx=4, vy=4, vw=12, ratio=2, path="src/view/arrow.png"}
cfg.cell          = {w=64, h=64, size=vec(64, 64)}
cfg.board         = {vx=2, vw=96, vy=15, cols=5, rows=5}
cfg.player        = {vw=6, ratio=1,
  red             = {vx=18, vy=4},
  black           = {vx=18, vy=9}
}
cfg.jade          = {w=cfg.cell.w, h=cfg.cell.h, path="src/view/jade.png", 
  moves           = 1,          -- drop jades every Nth move
  probability     = 0.2   -- probability that a jade will spawn on a cell
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