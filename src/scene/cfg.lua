local cfg = {
  app = require 'src.cfg',

  bg = {
    vx = 0,
    vy = 0,
    vw = 100,
    vh = 100,
    path = "src/background.png"
  },

  board = {
    cols = 8,
    rows = 8
  },

  switching = {
    effect = 'fade',
    time = 600
  },

  arrow = {
    x = 4,
    vy = 4,
    vw = 12,
    ratio = 2,
    path="src/view/arrow.png"
  },

  player = {
    red = {
      vx = 18,
      vy = 4
    },
    black = {
      vx = 18,
      vy = 9
    }
  }
}

return cfg