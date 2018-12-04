local vec   = require "src.core.vec"
local cfg   = require "src.Config"
local lay   = require "src.core.lay"
local log   = require "src.core.log"
local Ass   = require "src.core.Ass"
local Class  = require "src.core.Class"

local Cell = Class.Create('Cell')

function Cell:__tostring() return 'cell'.. tostring(self.pos) end

--
Cell.sheet_opt = {width = cfg.cell.w, height = cfg.cell.h, numFrames = 1}
Cell.sheet = graphics.newImageSheet("src/view/cell_1_s.png", Cell.sheet_opt)

--
function Cell.new(spot)
  Ass.Is(spot, 'Spot')
  local self = setmetatable({}, Cell)
  local frame = math.random(1, Cell.sheet_opt.numFrames);
  self.pos = spot.pos
  self.view = display.newGroup()
  self.img = lay.sheet(self.view, Cell.sheet, frame, cfg.cell)
  return self
end

-- JADE------------------------------------------------------------------------
--
function Cell:set_jade()
  Ass.Nil(self._jade)
  Ass.Nil(self._stone)
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
  Ass.Nil(self._stone)
  stone:set_pos(self.pos)
  self._stone = stone
end
--
function Cell:stone()
  return self._stone
end
--
function Cell:remove_stone()
  Ass(self._stone)
  local stone = self._stone
  stone:set_pos(nil)
  self._stone = nil
  return stone
end

-- MODULE-----------------------------------------------------------------------
Ass.Wrap(Cell, ':set_stone', 'Stone')
Ass.Wrap(Cell, ':stone')
Ass.Wrap(Cell, ':remove_stone')

log:wrap(Cell, 'set_jade', 'remove_jade', 'remove_stone', 'set_stone')
return Cell