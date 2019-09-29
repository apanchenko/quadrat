local lay = require 'src.lua-cor.lay'

local cfg = {
  app = require 'src.cfg',

  bg =
  {
    z = 1,
    x = 0,
    y = 0,
    vw = 100,
    vh = 100,
    path = "src/background.png",
    fn = lay.new_image
  },

  board =
  {
    cols = 7,
    rows = 7,
    view =
    {
      vx = 0,
      vy = 15,
      vw = 100,
      z = 4
    }
  },

  switching =
  {
    effect = 'fade',
    time = 600
  },

  arrow =
  {
    z = 3,
    x = 4,
    vy = 4,
    vw = 12,
    ratio = 2,
    path="images/board/arrow.png"
  },

  player = {
    red = {
      vx = 18,
      vy = 4,
      z = 2
    },
    black = {
      vx = 18,
      vy = 9,
      z = 3
    }
  }
}

return cfg