local Cell     = require 'src.view.Cell'
local Stone    = require 'src.view.Stone'
local Vec      = require 'src.core.Vec'
local Player   = require 'src.Player'
local Color    = require 'src.model.Color'
local Piece    = require 'src.model.Piece'
local cfg      = require 'src.Config'
local Type     = require 'src.core.Type'
local lay      = require 'src.core.lay'
local Ass      = require 'src.core.Ass'
local log      = require 'src.core.log'

local Board = Type.Create 'Board'

-------------------------------------------------------------------------------
function Board:__tostring()
  return "board"
end

--[[-----------------------------------------------------------------------------
  size of the board
  scale to device
  group to render
  grid with cells and pieces
  player color who moves now
  selected piece
-----------------------------------------------------------------------------]]--
function Board.new(battle, space)
  local self = setmetatable({}, Board)
  self.battle = battle
  self.model = space
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
function Board:cell(pos)
  return self.grid[pos.x * self.model:width() + pos.y]            -- peek piece from cell by position
end
-------------------------------------------------------------------------------
function Board:select_cells(filter)
  local selected = {}
  for k, cell in ipairs(self.grid) do
    if filter(cell) then
      selected[#selected + 1] = cell
    end
	end
  return selected
end
-------------------------------------------------------------------------------
function Board:get_cells()
  return self.grid 
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
-- model listener
function Board:spawn_piece(color, pos)
  local stone = Stone.New(color, self.model) -- create a new stone
  self.grid[self.model:index(pos)]:set_stone(stone) -- cell that actor is going to move to
  stone:puton(self, pos) -- put piece on board
end
-- model listener
function Board:move_piece(to, from)
  local stone = self:cell(from):remove_stone()
  self:cell(to):set_stone(stone)
end
-- model listener
function Board:remove_piece(pos)
  local stone = self:cell(pos):remove_stone()
  stone:putoff()
end
-- model listener
function Board:add_ability(pos, ability_name)
  local cell = self:cell(pos)
  Ass.Is(cell, Cell)
  local stone = cell:stone()
  Ass.Is(stone, Stone)
  stone:add_ability(ability_name)
end
-- model listener
function Board:remove_ability(pos, ability_name)
  local cell = self:cell(pos)
  Ass.Is(cell, Cell)
  local stone = cell:stone()
  Ass.Is(stone, Stone)
  stone:remove_ability(ability_name)
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
--[[
Ass.Wrap(Board, 'add_ability', Vec, 'string')
Ass.Wrap(Board, 'remove_ability', Vec, 'string')

log:wrap(Board, 'add_ability', 'remove_ability')
--]]
return Board