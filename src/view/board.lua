local cell     = require 'src.view.spot.cell'
local stone    = require 'src.view.stone'
local vec      = require 'src.core.vec'
local piece    = require 'src.model.piece'
local cfg      = require 'src.cfg'
local obj      = require 'src.core.obj'
local lay      = require 'src.core.lay'
local ass      = require 'src.core.ass'
local log      = require 'src.core.log'
local typ      = require 'src.core.typ'
local evt      = require 'src.core.evt'
local wrp      = require 'src.core.wrp'
local env      = require 'src.core.env'

local board = obj:extend('board')

--[[-----------------------------------------------------------------------------
  size of the board
  scale to device
  group to render
  grid with cells and pieces
  player color who moves now
  selected piece
-----------------------------------------------------------------------------]]--
function board:new()
  self = obj.new(self,
  {
    on_change = evt:new()
  })
  env.space.own_evt:add(self)
  self.view = display.newGroup()

  self.grid = {}
  for k, spot in env.space:spots() do
    local cell = cell:new(spot)
    lay.render(self, cell, cell.pos * cfg.view.cell.size)
    self.grid[k] = cell
  end

  self.view.anchorChildren = true          -- center on screen
  lay.render(env.battle, self.view, cfg.view.board)
  return self
end


-- POSITION--------------------------------------------------------------------
-- peek piece from cell by position
function board:cell(pos)
  return self.grid[pos.x * env.space:width() + pos.y]            
end
--
function board:stone(pos)
  return self:cell(pos):stone()
end

-- JADE -----------------------------------------------------------------------
-- model listener
function board:spawn_jade(pos)
  self:cell(pos):set_jade()
end
-- model listener
function board:remove_jade(pos)
  self:cell(pos):remove_jade()
end
--
function board:stash_jade(pos)
  if self.jade_stash == nil then
    self.jade_stash = {}
  end
  self:cell(pos):stash_jade(self.jade_stash)
end
--
function board:unstash_jade(pos)
  self:cell(pos):unstash_jade(self.jade_stash)
end

-- PIECE -----------------------------------------------------------------------
function board:spawn_piece(color, pos)
  local stone = stone:new(color) -- create a new stone
  stone:puton(self) -- put piece on board
  self:cell(pos):set_stone(stone) -- cell that actor is going to move to
  self.on_change:call('on_spawn_stone', stone)
end
--
function board:move_piece(to, from)
  local stone = self:cell(from):remove_stone()
  self:cell(to):set_stone(stone)
end
--
function board:remove_piece(pos)
  local stone = self:cell(pos):remove_stone()
  stone:putoff()
end
--
function board:set_ability(pos, id, count)
  self:stone(pos):set_ability(id, count)
end
--
function board:add_power(pos, name, count)
  self:stone(pos):add_power(name, count)
end
--
function board:stash_piece(pos)
  if self.stash == nil then
    self.stash = {}
  end
  self:cell(pos):stash_piece(self.stash)
end
--
function board:unstash_piece(pos)
  self:cell(pos):unstash_piece(self.stash)
end
--
function board:set_color(pos, color)
  local stone = self:stone(pos)
  stone:set_color(color)
  self.on_change:call('on_stone_color_changed', stone)
end
--
function board:add_spot_comp(pos, id, count)
  local cell = self:cell(pos)
  cell:add_comp(id, count)
end

-------------------------------------------------------------------------------
-- select piece
function board:select(stone)
  for _, cell in pairs(self.grid) do
    local s = cell:stone()
    if s then
      s:deselect() -- deselect all
    end
  end

  if stone then
    stone:select() -- then select a new one
  end
end


-- MODULE ---------------------------------------------------------------------
function board:wrap()
  local pos = {'pos', vec}
  local id = {'id', typ.str}
  local count = {'count', typ.num}
  wrp.fn(board, 'set_ability',   {pos, id, count})
  wrp.fn(board, 'add_power',     {pos, {'name', typ.str}, count})
  wrp.fn(board, 'set_color',     {pos, {'pid', 'playerid'}})
  wrp.fn(board, 'add_spot_comp', {pos, id, count})
end

function board:test()
  ass.isname(board, 'board')
end

return board