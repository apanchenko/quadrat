local Cell = require("src.battle.Cell")
local Piece = require("src.battle.Piece")
local Pos = require("src.core.Pos")
local Player = require("src.Player")
local Config = require("src.Config")

Board = {}
Board.__index = Board
setmetatable(Board, {__call = function(cls, ...) return cls._new(...) end})

-------------------------------------------------------------------------------
function Board:__tostring()
  return "board "..tostring(self.size)
end

--[[
  size of the board
  scale to device
  group to render
  grid with cells and pieces
  player color who moves now
  selected piece
--]]
function Board._new(size)
  local self = setmetatable({}, Board)
  self.size = size

  local scale = display.contentWidth / (8 * Config.cell_size.x);
  self.scale = Pos(scale, scale)            -- 2D scale
  self.group = display.newGroup()           -- disply group
  self.group:scale(self.scale.x, self.scale.y)

  self.grid = {}
  for i = 0, self.size.x - 1 do
    self.grid[i] = {}
    for j = 0, self.size.y - 1 do
      local cell = Cell()
      cell:insert_into(self, i, j)
      self.grid[i][j] = cell
    end
  end

  self.color = Player.Red

  self.group.anchorChildren = true          -- center on screen
  self.selected_piece = nil                 -- one piece may be selected
  Pos.center(self.group)

  return self
end

-------------------------------------------------------------------------------
-- set move listener as object:function(color)
function Board:set_move_listener(move_listener)
  assert(move_listener)
  assert(move_listener.moved)
  assert(type(move_listener.moved) == "function")
  self.move_listener = move_listener        -- move listener
end

-------------------------------------------------------------------------------
-- two rows initial position
function Board:position_default()
  local lastrow = self.size.y - 1
  for x = 0, self.size.x - 1 do
    self:put(Player.Red, Pos(x, 0))
    self:put(Player.Red, Pos(x, 1))
    self:put(Player.Black, Pos(x, lastrow))
    self:put(Player.Black, Pos(x, lastrow - 1))
  end
end

-------------------------------------------------------------------------------
-- one row initial position
function Board:position_minimal()
  for x = 0, self.size.x - 1 do
    self:put(Player.Red, Pos(x, 0))
    self:put(Player.Black, Pos(x, self.size.y - 1))
  end
end

-------------------------------------------------------------------------------
function Board:put(color, to)
  assert(Pos(0, 0) <= to)                   -- check to position is on board
  assert(to < self.size)
  local piece = Piece(color)                -- create a new piece
  self.grid[to.x][to.y].piece = piece       -- assign to cell
  piece:puton(self, to)                     -- put piece on board
end

-------------------------------------------------------------------------------
function Board:cell(pos)
  return self.grid[pos.x][pos.y]            -- peek piece from cell by position
end

-------------------------------------------------------------------------------
-- Check if piece can move from one position to another
function Board:can_move(fr, to)
  -- check move rights
  local actor = self:cell(fr).piece         -- peek piece at from position
  if actor == nil then                      -- check if it exists
    return false                            -- can not move
  end
  if actor.color ~= self.color then         -- check color who moves now
    return false                            -- can not move
  end

  -- check move ability
  local vec = actor.pos - to                -- movement vector
  if vec.x ~= 0 and vec.y ~= 0 then         -- allow orthogonal move only
    return false
  end
  if vec:length2() ~= 1 then                -- allow move one cell at a time
    return false                            -- can not move
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
function Board:move(fr, to)
  -- take actor piece
  local actor = self:cell(fr).piece         -- get piece at from position
  self.grid[fr.x][fr.y].piece = nil         -- erase piece from previous cell

  local tocell = self:cell(to)              -- cell that actor is going to move to

  -- kill victim
  if tocell.piece then                      -- peek possible victim at to position
    tocell.piece:die()
    tocell.piece = nil
  end

  -- consume jade to get ability
  if tocell.jade then
    tocell.jade:die()
    tocell.jade = nil
    actor:add_ability()
  end

  -- assign actor piece to new position
  self.grid[to.x][to.y].piece = actor       -- set piece to new cell
  actor:move(to)                            -- move piece to new position

  local moved_color = self.color

  self.color = not self.color               -- switch to another player

  self.move_listener:moved(moved_color)     -- notify listener about player moved
end

-------------------------------------------------------------------------------
function Board:count_pieces()
  --assert(type(color) == type(Player.Red), "Wrong color type")
  local red = 0
  local bla = 0
  for i = 0, self.size.x - 1 do
    for j = 0, self.size.y - 1 do
      local piece = self:cell(Pos(i, j)).piece
      if piece then
        if piece.color == Player.Red then
          red = red + 1
        else
          bla = bla + 1
        end
      end
    end
  end
  return red, bla
end

-------------------------------------------------------------------------------
-- randomly spawn jades in cells
function Board:drop_jades(jade_probability)
  for i = 0, self.size.x - 1 do
    for j = 0, self.size.y - 1 do
      local cell = self:cell(Pos(i, j))
      cell:drop_jade(jade_probability)
    end
  end
end

-------------------------------------------------------------------------------
-- select piece
function Board:select(piece)
  if self.selected_piece then
    self.selected_piece:deselect()
  end

  self.selected_piece = piece
  if self.selected_piece then
    self.selected_piece:select()
  end
end

-------------------------------------------------------------------------------
-- select piece
function Board:is_color(color)
  return self.color == color
end

return Board