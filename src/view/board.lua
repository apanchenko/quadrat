local cell     = require 'src.view.spot.cell'
local stone    = require 'src.view.stone.stone'
local vec      = require 'src.lua-cor.vec'
local piece    = require 'src.model.piece'
local cfg      = require 'src.cfg'
local obj      = require 'src.lua-cor.obj'
local lay      = require 'src.lua-cor.lay'
local ass      = require 'src.lua-cor.ass'
local log      = require 'src.lua-cor.log'
local typ      = require 'src.lua-cor.typ'
local evt      = require 'src.lua-cor.evt'
local wrp      = require 'src.lua-cor.wrp'
local env      = require 'src.lua-cor.env'
local arr      = require 'src.lua-cor.arr'

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
    local param = cell.pos * cfg.view.cell.size
    param.z = 1
    lay.insert(self.view, cell.view, param)
    self.grid[k] = cell
  end

  self.view.anchorChildren = true          -- center on screen
  lay.insert(env.battle.view, self.view, cfg.view.board)
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
    self.jade_stash = arr()
  end
  self:cell(pos):stash_jade(self.jade_stash)
end
--
function board:unstash_jade(pos)
  self:cell(pos):unstash_jade(self.jade_stash)
end

-- PIECE -----------------------------------------------------------------------
function board:spawn_piece(color, pos)
  local stone = stone:new(env, color) -- create a new stone
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
    self.stash = arr()
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
  wrp.wrap_sub_trc(board, 'set_ability',   pos, id, count)
  wrp.wrap_sub_inf(board, 'add_power',     pos, {'name', typ.str}, count)
  wrp.wrap_sub_inf(board, 'set_color',     pos, {'pid', 'playerid'})
  wrp.wrap_sub_inf(board, 'add_spot_comp', pos, id, count)
end

function board:test()
  ass.isname(board, 'board')
end

return board