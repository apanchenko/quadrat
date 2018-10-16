local Cell     = require 'src.battle.Cell'
local Piece    = require 'src.battle.Piece'
local Vec      = require 'src.core.vec'
local Player   = require 'src.Player'
local Color    = require 'src.battle.Color'
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
function Board.new(battle)
  local self = setmetatable({}, Board)
  self.battle = battle
  self.cols = cfg.board.cols
  self.rows = cfg.board.rows
  self.view = display.newGroup()
  self.hover = display.newGroup()

  self.grid = {}
  for i = 0, self.cols - 1 do
  for j = 0, self.rows - 1 do
    local cell = Cell.new(Vec(i, j))
    lay.render(self, cell, cell.pos * cfg.cell.size)
    self.grid[i * self.cols + j] = cell
  end
  end

  self.color = Color.R

  self.view.anchorChildren = true          -- center on screen
  Vec.center(self.view)
  lay.render(self.battle, self.view, cfg.board)
  lay.render(self.battle, self.hover, cfg.board)
  return self
end



-------------------------------------------------------------------------------
-- POSITION--------------------------------------------------------------------
-------------------------------------------------------------------------------
-- set move listener as object:function(color)
function Board:set_tomove_listener(tomove_listener)
  assert(tomove_listener)
  assert(tomove_listener.tomove)
  assert(type(tomove_listener.tomove) == "function")
  self.tomove_listener = tomove_listener    -- move listener
end
-------------------------------------------------------------------------------
-- two rows initial position
function Board:position_default()
  local lastrow = self.rows - 1
  for x = 0, self.cols - 1 do
    self:put(Color.R, x, 0)
    self:put(Color.R, x, 1)
    self:put(Color.B, x, lastrow)
    self:put(Color.B, x, lastrow - 1)
  end
end
-------------------------------------------------------------------------------
-- one row initial position
function Board:position_minimal()
  for x = 0, self.cols - 1 do
    self:put(Color.R, x, 0)
    self:put(Color.B, x, self.rows - 1)
  end
end
-------------------------------------------------------------------------------
function Board:put(color, x, y)
  local log_depth = log:trace(self, ":put"):enter()
    assert(0 <= x and x < self.cols)
    assert(0 <= y and y < self.rows)
    local piece = Piece.new(color)                -- create a new piece
    piece:puton(self, self.grid[x * self.cols + y])                     -- put piece on board
  log:exit(log_depth)
end
-------------------------------------------------------------------------------
function Board:cell(pos)
  return self.grid[pos.x * self.cols + pos.y]            -- peek piece from cell by position
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
-- Check if piece can move from one position to another
function Board:can_move(fr, to)
  ass.is(fr, Vec)
  ass.is(to, Vec)

  -- check move rights
  local actor = self:cell(fr).piece        -- peek piece at from position
  if actor == nil then                      -- check if it exists
    return false                            -- can not move
  end
  if actor.color ~= self.color then         -- check color who moves now
    return false                            -- can not move
  end

  -- check move ability
  if not actor:can_move(to) then
    return false
  end

  -- check kill ability
  local tocell = self:cell(to)
  local victim = tocell.piece               -- peek piece at to position
  if victim then
    if victim.color == actor.color then
      return false                            -- can not kill piece of the same breed
    end
    if victim:is_jump_protected() then
      return false
    end
  end

  return true
end
-------------------------------------------------------------------------------
function Board:move(cell_from, vec_to)
  ass.is(cell_from, Cell)
  ass.is(vec_to, Vec)

  local cell_to   = self:cell(vec_to)      -- cell that actor is going to move to
  local piece     = cell_from.piece

  piece:move_before(cell_from, cell_to)
  piece:move_middle(cell_from, cell_to)
  piece:move_after (cell_from, cell_to)
end
-------------------------------------------------------------------------------
function Board:player_move(cell_from, to_pos)
  self:move(cell_from, to_pos)
  self.color = not self.color               -- switch to another player
  self.tomove_listener:tomove(self.color)   -- notify listener about player moved
end

-------------------------------------------------------------------------------
function Board:count_pieces()
  local red = 0
  local bla = 0
  for k, cell in ipairs(self.grid) do
    local piece = cell.piece
    if piece then
      if piece.color == Color.R then
        red = red + 1
      else
        bla = bla + 1
      end
    end
  end
  return red, bla
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

-------------------------------------------------------------------------------
-- select piece
function Board:is_color(color)
  return self.color == color
end

return Board