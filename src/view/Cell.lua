local vec   = require "src.core.Vec"
local cfg   = require "src.Config"
local lay   = require "src.core.lay"
local log   = require "src.core.log"
local ass   = require "src.core.ass"

Cell = { typename = 'Cell' }
Cell.__index = Cell

function Cell:__tostring() return 'cell'.. tostring(self.pos) end

--
Cell.sheet_opt = {width = cfg.cell.w, height = cfg.cell.h, numFrames = 2}
Cell.sheet = graphics.newImageSheet("src/battle/cell_1_s.png", Cell.sheet_opt)

--
function Cell.new(spot)
  ass.is(spot, 'Spot')
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
  ass.nul(self.jade, 'jade')
  ass.nul(self.piece, 'piece')
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
function Cell:remove_stone()
  log:trace(self, ':remove_stone')
  ass.is(self.stone, 'Stone')
  local stone = self.stone
  stone:set_pos(nil)
  self.stone = nil
  return stone
end
--
function Cell:set_stone(stone)
  log:trace(self, ':set_stone')
  ass.is(stone, 'Stone')
  stone:set_pos(self.pos)
  self.stone = stone
end


return Cell