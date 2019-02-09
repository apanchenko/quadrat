local vec   = require "src.core.vec"
local cfg   = require "src.model.cfg"
local lay   = require "src.core.lay"
local log   = require "src.core.log"
local ass   = require "src.core.ass"
local obj   = require "src.core.obj"
local wrp   = require 'src.core.wrp'
local Spot  = require 'src.model.Spot'

local Cell = obj:extend('Cell')

function Cell:__tostring() return 'cell'.. tostring(self.pos) end

--
Cell.sheet_opt = {width = cfg.cell.w, height = cfg.cell.h, numFrames = 1}
Cell.sheet = graphics.newImageSheet("src/view/cell_1_s.png", Cell.sheet_opt)

--
function Cell:new(spot)
  ass.is(spot, Spot)
  local frame = math.random(1, Cell.sheet_opt.numFrames);
  self = obj.new(self, 
  {
    pos = spot.pos,
    view = display.newGroup(),
  })
  self.img = lay.sheet(self.view, Cell.sheet, frame, cfg.cell)
  return self
end

-- JADE------------------------------------------------------------------------
--
function Cell:set_jade()
  ass.nul(self._jade)
  ass.nul(self._stone)
  self._jade = lay.image(self.view, cfg.jade)
end
--
function Cell:remove_jade()
  assert(self._jade)
  self._jade:removeSelf()
  self._jade = nil
end

-- STONE-----------------------------------------------------------------------
--
function Cell:set_stone(stone)
  ass.nul(self._stone)
  stone:set_pos(self.pos)
  self._stone = stone
end
--
function Cell:stone()
  return self._stone
end
--
function Cell:remove_stone()
  ass(self._stone)
  local stone = self._stone
  self._stone = nil
  return stone
end

-- MODULE-----------------------------------------------------------------------
function Cell.wrap()
  ass(log.info)
  local info = {log = log.info}
  wrp.fn(Cell, 'set_stone',   {{'Stone'}})
  wrp.fn(Cell, 'stone',       {}, info)
  wrp.fn(Cell, 'remove_stone')
end

return Cell