local Cell     = require 'src.view.Cell'
local Stone    = require 'src.view.Stone'
local Vec      = require 'src.core.vec'
local Player   = require 'src.Player'
local Piece    = require 'src.model.Piece'
local cfg      = require 'src.model.cfg'
local obj      = require 'src.core.obj'
local lay      = require 'src.core.lay'
local ass      = require 'src.core.ass'
local log      = require 'src.core.log'
local typ      = require 'src.core.typ'
local evt      = require 'src.core.evt'
local wrp      = require 'src.core.wrp'

local Board = obj:extend('Board')

--[[-----------------------------------------------------------------------------
  size of the board
  scale to device
  group to render
  grid with cells and pieces
  player color who moves now
  selected piece
-----------------------------------------------------------------------------]]--
function Board:new(battle, space)
  self = obj.new(self,
  {
    battle = battle,
    model = space,
    on_change = evt:new()
  })
  self.model.on_change:add(self)
  self.view = display.newGroup()

  self.grid = {}
  for k, spot in space:spots() do
    local cell = Cell:new(spot)
    lay.render(self, cell, cell.pos * cfg.cell.size)
    self.grid[k] = cell
  end

  self.view.anchorChildren = true          -- center on screen
  lay.render(self.battle, self.view, cfg.board)
  return self
end


-- POSITION--------------------------------------------------------------------
-- peek piece from cell by position
function Board:cell(pos)
  return self.grid[pos.x * self.model:width() + pos.y]            
end
--
function Board:stone(pos)
  return self:cell(pos):stone()
end

-- JADE -----------------------------------------------------------------------
-- model listener
function Board:spawn_jade(pos)
  self:cell(pos):set_jade()
end
-- model listener
function Board:remove_jade(pos)
  self:cell(pos):remove_jade()
end

-- PIECE -----------------------------------------------------------------------
function Board:spawn_piece(color, pos)
  local stone = Stone:new(color, self.model) -- create a new stone
  stone:puton(self) -- put piece on board
  self:cell(pos):set_stone(stone) -- cell that actor is going to move to
  self.on_change:call('on_spawn_stone', stone)
end
--
function Board:move_piece(to, from)
  local stone = self:cell(from):remove_stone()
  self:cell(to):set_stone(stone)
end
--
function Board:remove_piece(pos)
  local stone = self:cell(pos):remove_stone()
  stone:putoff()
end
--
function Board:set_ability(pos, id, count)
  self:stone(pos):set_ability(id, count)
end
--
function Board:add_power(pos, name, count)
  self:stone(pos):add_power(name, count)
end
--
function Board:set_color(pos, color)
  self:stone(pos):set_color(color)
end

-------------------------------------------------------------------------------
-- select piece
function Board:select(stone)
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
function Board.wrap()
  wrp.fn(Board, 'set_ability',  {{'pos', Vec}, {'id', typ.str}, {'count', typ.num}})
  wrp.fn(Board, 'add_power',    {{'pos', Vec}, {'name', typ.str}, {'count', typ.num}})
  wrp.fn(Board, 'set_color',    {{'pos', Vec}, {'pid', 'playerid'}})
end

return Board