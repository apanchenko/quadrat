local vec = require('src.lua-cor.vec')

local cfg =
{
  version  = '0.0.1',
  log_info = false
}

cfg.view = {
  vw = display.contentWidth / 100,
  vh = display.contentHeight / 100,
  font = native.systemFont,
}

cfg.view.origin = {
  vx = 0,
  vy = 0
}

cfg.view.battle = {
  bg = {
    vx = 0,
    vy = 0,
    vw = 100,
    vh = 100,
    path="src/background.png"
  },
}

cfg.view.player =
{
  z = 2,
  vx = 0,
  vy = 0,
  vw = 6,
  ratio = 1,
}

cfg.view.cell =
{
  z = 2,
  vx = 0,
  vy = 0,
  w = 64,
  h = 64,
  size = vec(64, 64)
}

cfg.view.jade =
{
  z = 5,
  vx = 0,
  vy = 0,
  w = cfg.view.cell.w,
  h = cfg.view.cell.h,
  path = "images/board/jade.png",
}

cfg.view.stone = {
  move = {
    time = 500,
    transition = easing.inOutQuad
  }
}

cfg.view.abilities = {
  vx = 9,
  y = (cfg.view.vh * 15) + (cfg.view.vw * 100) + cfg.view.vh,
  z = 2,
  button =
  {
    x = 0,
    y = 0,
    vw = 40,
    height = 16,
    z = 3,
    emboss = false,
    font = cfg.view.font,
    fontSize = 14,
    shape = "roundedRect",
    cornerRadius = 3,
    fillColor   = { default = {0.3, 0.4, 0.5, 1.0}, over = {0.6, 0.7, 0.8, 0.8} },
    labelColor  = { default = {1.0, 1.0, 1.0, 1.0}, over = {1.0, 1.0, 1.0, 1.0} },
    strokeColor = { default = {0.3, 0.4, 0.5, 0.5}, over = {0.8, 0.8, 1.0, 1.0} },
    strokeWidth = 1
  },
  rows = {
    length = 2,
    space_px = 2,
    space_py = 1
  }
}

return cfg