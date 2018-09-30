local Cell    = require "src.battle.Cell"
local Piece   = require "src.battle.Piece"
local vec     = require "src.core.vec"
local Player  = require "src.Player"
local cfg     = require "src.Config"
local str     = tostring

Board = {}
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
function Board.new(log)
  local self = setmetatable({log = log}, Board)
  self.cols = cfg.board.cols
  self.rows = cfg.board.rows
  self.view = display.newGroup()           -- disply group

  self.grid = {}
  for i = 0, self.cols - 1 do
  for j = 0, self.rows - 1 do
    local cell = Cell.new(vec(i, j))
    lay.render(self, cell, cell.pos * cfg.cell.size)
    self.grid[i * self.cols + j] = cell
  end
  end

  self.color = Player.R

  self.view.anchorChildren = true          -- center on screen
  vec.center(self.view)

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
    self:put(Player.R, x, 0)
    self:put(Player.R, x, 1)
    self:put(Player.B, x, lastrow)
    self:put(Player.B, x, lastrow - 1)
  end
end
-------------------------------------------------------------------------------
-- one row initial position
function Board:position_minimal()
  for x = 0, self.cols - 1 do
    self:put(Player.R, x, 0)
    self:put(Player.B, x, self.rows - 1)
  end
end
-------------------------------------------------------------------------------
function Board:put(color, x, y)
  assert(0 <= x and x < self.cols)
  assert(0 <= y and y < self.rows)
  local piece = Piece(self.log, color)                -- create a new piece
  piece:puton(self, self.grid[x * self.cols + y])                     -- put piece on board
end
-------------------------------------------------------------------------------
function Board:cell(pos)
  return self.grid[pos.x * self.cols + pos.y]            -- peek piece from cell by position
end
-------------------------------------------------------------------------------
function Board:select_cells(filter)
  local selected = {}
  for k, v in ipairs(self.grid) do
    if filter(v) then
      selected[#selected + 1] = v
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
  if victim and victim.color == actor.color then
    return false                            -- can not kill piece of the same breed
  end

  return true
end
-------------------------------------------------------------------------------
function Board:move(from_pos, to_pos)
  local cell_from = self:cell(from_pos)    -- get piece at from position
  local cell_to   = self:cell(to_pos)      -- cell that actor is going to move to
  local piece     = cell_from.piece

  self:move_before(piece, cell_from, cell_to)
  self:move_middle(piece, cell_from, cell_to)
  self:move_after (piece, cell_from, cell_to)
end
-------------------------------------------------------------------------------
function Board:player_move(from_pos, to_pos)
  self:move(from_pos, to_pos)
  self.color = not self.color               -- switch to another player
  self.tomove_listener:tomove(self.color)   -- notify listener about player moved
end
-------------------------------------------------------------------------------
function Board:move_before(piece, cell_from, cell_to)
  piece:move_before(cell_from, cell_to)
end
-------------------------------------------------------------------------------
function Board:move_middle(piece, cell_from, cell_to)
  piece:move(cell_from, cell_to)            -- move piece to new position
end
-------------------------------------------------------------------------------
function Board:move_after(piece, cell_from, cell_to)
  piece:move_after(cell_from, cell_to)
end



-------------------------------------------------------------------------------
function Board:count_pieces()
  local red = 0
  local bla = 0
  for k, cell in ipairs(self.grid) do
    local piece = cell.piece
    if piece then
      if piece.color == Player.R then
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