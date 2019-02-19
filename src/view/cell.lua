local vec   = require "src.core.vec"
local cfg   = require "src.model.cfg"
local lay   = require "src.core.lay"
local log   = require "src.core.log"
local ass   = require "src.core.ass"
local obj   = require "src.core.obj"
local wrp   = require 'src.core.wrp'
local spot  = require 'src.model.spot'

local cell = obj:extend('cell')

function cell:__tostring() return 'cell'.. tostring(self.pos) end

--
cell.sheet_opt = {width = cfg.cell.w, height = cfg.cell.h, numFrames = 1}
cell.sheet = graphics.newImageSheet("src/view/cell_1_s.png", cell.sheet_opt)

--
function cell:new(spot)
  local frame = math.random(1, cell.sheet_opt.numFrames);
  self = obj.new(self, 
  {
    pos = spot.pos,
    view = display.newGroup(),
  })
  self.img = lay.sheet(self.view, cell.sheet, frame, cfg.cell)
  return self
end

-- JADE------------------------------------------------------------------------
--
function cell:set_jade()
  ass.nul(self._jade)
  ass.nul(self._stone)
  self._jade = lay.image(self.view, cfg.jade)
end
--
function cell:remove_jade()
  assert(self._jade)
  self._jade:removeSelf()
  self._jade = nil
end

-- STONE-----------------------------------------------------------------------
--
function cell:set_stone(stone)
  ass.nul(self._stone)
  stone:set_pos(self.pos)
  self._stone = stone
end
--
function cell:stone()
  return self._stone
end
--
function cell:remove_stone()
  ass(self._stone)
  local stone = self._stone
  self._stone = nil
  return stone
end

-- MODULE-----------------------------------------------------------------------
function cell.wrap()
  ass(log.info)
  local info = {log = log.info}
  wrp.fn(cell, 'new',         {{'spot'}})
  wrp.fn(cell, 'set_stone',   {{'stone'}})
  wrp.fn(cell, 'stone',       {}, info)
  wrp.fn(cell, 'remove_stone')
end

return cell