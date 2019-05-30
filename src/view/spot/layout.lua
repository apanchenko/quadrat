local lay = require 'src.lua-cor.lay'
local cfg = require 'src.cfg'

local layout = lay.new_layout()

local sheet_opt = {width = cfg.view.cell.w, height = cfg.view.cell.h, numFrames = 1}

layout.add('cell',
{
  z = 1,
  x = 0,
  y = 0,
  w = 64,
  h = 64,
  sheet = graphics.newImageSheet("src/view/spot/cell_1_s.png", sheet_opt),
  frame = math.random(1, sheet_opt.numFrames),
  fn = lay.sheet
})

return layout