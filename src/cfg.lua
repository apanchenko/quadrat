local bld = require 'src.core.bld'
local vec = require 'src.core.vec'

local cfg = {
  build   = bld.develop,
  version = '0.0.1',
  
  scenes = {
    switching = {effect = 'fade', time = 600}
  },
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
  arrow = {
    x = 4,
    vy = 4,
    vw = 12,
    ratio = 2,
    path="src/view/arrow.png"
  }
}

cfg.view.board = {
  vx = 0,
  vy = 15,
  vw = 100,
  cols = 8,
  rows = 8
}

cfg.view.cell = {
  vx = 0,
  vy = 0,
  w = 64,
  h = 64,
  size = vec(64, 64)
}

cfg.view.player = {
  vx = 0,
  vy = 0,
  vw = 6,
  ratio = 1,
  red = {
    vx = 18,
    vy = 4
  },
  black = {
    vx = 18,
    vy = 9
  }
}

cfg.view.jade = {
  vx = 0,
  vy = 0,
  w = cfg.view.cell.w,
  h = cfg.view.cell.h,
  path = "src/view/jade.png", 
}

cfg.view.stone = {
  move = {
    time = 500,
    transition = easing.inOutQuad
  }
}

cfg.view.abilities = {
  vx = 9,
  y = (cfg.view.vh * cfg.view.board.vy) + (cfg.view.vw * cfg.view.board.vw) + cfg.view.vh,
  button = {
    x = 0,
    y = 0,
    vw = 40,
    height = 16,
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