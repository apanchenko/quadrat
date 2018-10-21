local Cell     = require 'src.view.Cell'
local Stone    = require 'src.view.Stone'
local Vec      = require 'src.core.vec'
local Player   = require 'src.Player'
local Color    = require 'src.model.Color'
local cfg      = require 'src.Config'
local lay      = require 'src.core.lay'
local ass      = require 'src.core.ass'
local log      = require 'src.core.log'

Board = {typename='Board'}
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
function Board.new(battle, model)
  local self = setmetatable({}, Board)
  self.battle = battle
  self.model = model
  self.view = display.newGroup()
  self.hover = display.newGroup()

  self.grid = {}
  for k, v in model:spots() do
    local vcell = Cell.new(model:pos(k))
    lay.render(self, vcell, vcell.pos * cfg.cell.size)
    self.grid[k] = vcell
  end

  for k, v in model:pieces() do
    Stone.new(v):puton(self, self.grid[k])  
  end

  self.view.anchorChildren = true          -- center on screen
  Vec.center(self.view)
  lay.render(self.battle, self.view, cfg.board)
  lay.render(self.battle, self.hover, cfg.board)
  return self
end


-------------------------------------------------------------------------------
-- POSITION--------------------------------------------------------------------
-------------------------------------------------------------------------------
function Board:put(color, x, y)
  local log_depth = log:trace(self, ":put"):enter()
    assert(0 <= x and x < self.model:width())
    assert(0 <= y and y < self.model:height())
    local stone = Stone.new(color)                -- create a new piece
    stone:puton(self, self.grid[x * self.model:width() + y])                     -- put piece on board
  log:exit(log_depth)
end
-------------------------------------------------------------------------------
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



-------------------------------------------------------------------------------
-- MOVE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function Board:move(cell_from, vec_to)
  ass.is(cell_from, Cell)
  ass.is(vec_to, Vec)

  local cell_to   = self:cell(vec_to)      -- cell that actor is going to move to
  local piece     = cell_from.piece

  piece:move_before(cell_from, cell_to)
  piece:move_middle(cell_from, cell_to)
  piece:move_after (cell_from, cell_to)

  self.model:move(cell_from.pos, vec_to)
end

-------------------------------------------------------------------------------
-- randomly spawn jades in cells
function Board:drop_jades()
  for _, cell in ipairs(self.grid) do
    cell:drop_jade(cfg.jade.probability)
  end
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