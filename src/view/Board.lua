local Cell     = require 'src.view.Cell'
local Stone    = require 'src.view.Stone'
local Vec      = require 'src.core.Vec'
local Player   = require 'src.Player'
local Color    = require 'src.model.Color'
local Piece    = require 'src.model.Piece'
local cfg      = require 'src.Config'
local lay      = require 'src.core.lay'
local ass      = require 'src.core.ass'
local log      = require 'src.core.log'

Board = { typename='Board' }
Board.__index = Board

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
  self.hover = display.newGroup()

  self.grid = {}
  for k, spot in space:spots() do
    local cell = Cell.new(spot)
    lay.render(self, cell, cell.pos * cfg.cell.size)
    self.grid[k] = cell
  end

  self.view.anchorChildren = true          -- center on screen
  Vec.center(self.view)
  lay.render(self.battle, self.view, cfg.board)
  lay.render(self.battle, self.hover, cfg.board)
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
  local stone = Stone.new(color) -- create a new stone
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

-------------------------------------------------------------------------------
-- select piece
function Board:select(piece)
  for _, cell in ipairs(self.grid) do
    if cell.piece then
      cell.piece:deselect()                 -- deselect all
    end
  end

  if piece then
    piece:select()                          -- then select a new one
  end
end

return Board