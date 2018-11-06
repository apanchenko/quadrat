local vec   = require "src.core.Vec"
local cfg   = require "src.Config"
local lay   = require "src.core.lay"
local log   = require "src.core.log"
local ass   = require "src.core.ass"

Cell = { typename = 'Cell' }
Cell.__index = Cell

function Cell:__tostring() return 'cell'.. tostring(self.pos) end

--
Cell.sheet_opt = {width = cfg.cell.w, height = cfg.cell.h, numFrames = 1}
Cell.sheet = graphics.newImageSheet("src/battle/cell_1_s.png", Cell.sheet_opt)

--
function Cell.new(spot)
  ass.Is(spot, 'Spot')
  local self = setmetatable({}, Cell)
  local frame = math.random(1, Cell.sheet_opt.numFrames);
  self.pos = spot:pos()
  self.view = display.newGroup()
  self.img = lay.sheet(self.view, Cell.sheet, frame, cfg.cell)
  return self
end

-- JADE------------------------------------------------------------------------
--
function Cell:set_jade()
  ass.Nil(self.jade, 'jade')
  ass.Nil(self.piece, 'piece')
  self.jade = lay.image(self.view, cfg.jade)
end
--
function Cell:remove_jade()
  assert(self.jade)
  self.jade:removeSelf()
  self.jade = nil
end

-- STONE-----------------------------------------------------------------------
--
function Cell:stone()
  return self._stone
end
--
function Cell:remove_stone()
  ass.Is(self._stone, 'Stone')
  local stone = self._stone
  stone:set_pos(nil)
  self._stone = nil
  return stone
end
--
function Cell:set_stone(stone)
  ass.Is(self, Cell)
  ass.Is(stone, 'Stone')
  stone:set_pos(self.pos)
  self._stone = stone
end

log:wrap(Cell, 'set_jade', 'remove_jade', 'remove_stone', 'set_stone')
return Cell