local vec   = require 'src.core.vec'
local arr   = require 'src.core.arr'
local cfg   = require 'src.cfg'
local lay   = require "src.core.lay"
local log   = require "src.core.log"
local ass   = require "src.core.ass"
local obj   = require "src.core.obj"
local wrp   = require 'src.core.wrp'
local spot  = require 'src.model.spot.spot'

local cell = obj:extend('cell')

function cell:__tostring() return 'cell'.. tostring(self.pos) end

--
cell.sheet_opt = {width = cfg.view.cell.w, height = cfg.view.cell.h, numFrames = 1}
cell.sheet = graphics.newImageSheet("src/view/spot/cell_1_s.png", cell.sheet_opt)

--
function cell:new(spot)
  local frame = math.random(1, cell.sheet_opt.numFrames);
  self = obj.new(self, 
  {
    pos = spot.pos,
    view = display.newGroup(),
  })
  self.img = lay.sheet(self.view, cell.sheet, frame, cfg.view.cell)
  return self
end

-- COMP------------------------------------------------------------------------
--
function cell:add_comp(id, count)
  if id == 'spot_acidic' then
    lay.image(self.view, {x=0, y=0, w=cfg.view.cell.w, h=cfg.view.cell.h, path='src/view/power/jumpproof.png'})
  end
end

-- JADE------------------------------------------------------------------------
--
function cell:set_jade()
  ass.nul(self._jade)
  ass.nul(self._stone)
  self._jade = lay.image(self.view, cfg.view.jade)
end
--
function cell:remove_jade()
  assert(self._jade)
  self._jade:removeSelf()
  self._jade = nil
end

-- put jade into special hidden place for a short time
function cell:stash_jade_before()
  ass(self._jade)
end
function cell:stash_jade(stash)
  local jade = self._jade
  self._jade = nil
  --jade:set_pos(nil)
  arr.push(stash, jade)
end
function cell:stash_jade_after()
  ass.nul(self._jade)
end

-- get jade from stash
function cell:unstash_jade_before()
  ass.nul(self._stone)
  ass.nul(self._jade)
end
function cell:unstash_jade(stash)
  self._jade = arr.pop(stash)
  --self._jade:set_pos(self.pos)
end
function cell:unstash_jade_after()
  ass(self._jade)
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

-- put piece into special hidden place for a short time
-- caller is responsible for stash
-- stash is a FILO stack
function cell:stash_piece_before()
  ass(self._stone)
end
function cell:stash_piece(stash)
  local piece = self._stone
  self._stone = nil
  piece:set_pos(nil)
  arr.push(stash, piece)
end
function cell:stash_piece_after()
  ass.nul(self._stone)
end

-- get piece from stash
-- caller is responsible for stash
-- stash is a FILO stack
function cell:unstash_piece_before()
  ass.nul(self._stone)
  ass.nul(self._jade)
end
function cell:unstash_piece(stash)
  self._stone = arr.pop(stash)
  self._stone:set_pos(self.pos)
end
function cell:unstash_piece_after()
  ass(self._stone)
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