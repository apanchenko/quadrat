local Cell     = require('src.view.spot.cell')
local Stone   = require('src.view.stone.stone')
local vec      = require('src.lua-cor.vec')
local cfg      = require 'src.cfg'
local obj      = require('src.lua-cor.obj')
local lay      = require('src.lua-cor.lay')
local log      = require('src.lua-cor.log').get('view')
local evt      = require 'src.lua-cor.evt'
local env      = require 'src.lua-cor.env'
local arr      = require 'src.lua-cor.arr'
local com      = require 'src.lua-cor.com'
local space_agent = require('src.model.space.agent')

local board = obj:extend('board')

-- private
local _space = {}
local _battle_view = {}

function board:new(space_board, battle_view)
  self = obj.new(self, com())
  self[_space] = space_board
  self[_battle_view] = battle_view

  self.on_change = evt:new()

  self[_space]:add_listener(self)

  self.view = lay.new_layout().new_group()

  self.grid = {}

  local size = self[_space]:get_size()
  size:iterate_grid(function(pos)
    local cell = Cell:new(pos)
    local param = cell.pos * cfg.view.cell.size
    param.z = 1
    param.w = 40
    param.h = 40
    lay.insert(self.view, cell.view, param)
    log.trace('Cell at', param.x, param.y)
    self.grid[pos:to_index_in_grid(size)] = cell
  end)
  --ass.eq(self.view.numChildren, 49)
  --self.view.walk_tree()

  self.view.anchorChildren = true -- center on screen
  return self
end

-- POSITION--------------------------------------------------------------------
-- peek piece from cell by position
function board:cell(pos)
  return self.grid[pos.x * self[_space]:get_size().x + pos.y]
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
  local space = space_agent:new(env.space, color)
  local stone = Stone:new(env, space:get_piece(pos)) -- create a new stone
  stone:puton(self, self[_battle_view]) -- put piece on board
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
function board:piece_add_power(pos, name, count)
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
function board:piece_set_color(pos, color)
  local stone = self:stone(pos)
  stone:set_color(color)
  self.on_change:call('on_stone_color_changed', stone)
end
--
function board:add_spot_comp(pos, id, count)
  local cel = self:cell(pos)
  cel:add_comp(id, count)
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
  local typ   = require('src.lua-cor.typ')
  local wrp   = require('src.lua-cor.wrp')
  local space_board = require('src.model.space.board')
  local playerid = require('src.model.playerid')
  local ex    = typ.new_ex(board)
  local id    = typ.str
  local count = typ.num

  wrp.fn(log.info, board, 'new',                 board, space_board, typ.tab)
  wrp.fn(log.trace, board, 'set_ability',        ex, vec, id, count)
  wrp.fn(log.info, board, 'piece_add_power',     ex, vec, typ.str, count)
  wrp.fn(log.info, board, 'piece_set_color',     ex, vec, playerid)
  wrp.fn(log.info, board, 'add_spot_comp',       ex, vec, typ.str, typ.num)
end

return board