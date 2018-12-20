local Cell     = require 'src.view.Cell'
local Stone    = require 'src.view.Stone'
local Vec      = require 'src.core.vec'
local Player   = require 'src.Player'
local Piece    = require 'src.model.Piece'
local cfg      = require 'src.Config'
local obj      = require 'src.core.obj'
local lay      = require 'src.core.lay'
local ass      = require 'src.core.ass'
local log      = require 'src.core.log'
local typ      = require 'src.core.typ'

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
    model = space
  })
  self.model.on_change:add(self)
  self.view = display.newGroup()

  self.grid = {}
  for k, spot in space:spots() do
    local cell = Cell.new(spot)
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

-- MOVE------------------------------------------------------------------------
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
  local stone = Stone.New(color, self.model) -- create a new stone
  self.grid[self.model:index(pos)]:set_stone(stone) -- cell that actor is going to move to
  stone:puton(self, pos) -- put piece on board
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
function Board:add_ability(pos, ability_name)
  self:stone(pos):add_ability(ability_name)
end
--
function Board:remove_ability(pos, ability_name)
  self:stone(pos):remove_ability(ability_name)
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
---[[
ass.wrap(Board, ':add_ability', Vec, typ.str)
ass.wrap(Board, ':remove_ability', Vec, typ.str)
ass.wrap(Board, ':add_power', Vec, typ.str, typ.num)
ass.wrap(Board, ':set_color', Vec, 'playerid')

log:wrap(Board, 'add_ability', 'remove_ability', 'add_power')
--]]
return Board