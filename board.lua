local Cell = require("cell")
local Piece = require("piece")
local Pos = require("Pos")

Board = {}
Board.__index = Board
setmetatable(Board, {__call = function(cls, ...) return cls.new(...) end})

-------------------------------------------------------------------------------
function Board:__tostring()
  return "board "..tostring(self.size)
end

-------------------------------------------------------------------------------
-- size of the board
-- scale to device
-- group to render
-- grid with cells and pieces
-- color who moves now
function Board.new(width, height)
  local self = setmetatable({}, Board)
  self.size = Pos(width or 8, height or 8)

  local scale = display.contentWidth / (8 * Cell.size.x);
  self.scale = Pos(scale, scale)
  self.group = display.newGroup()
  self.group:scale(self.scale.x, self.scale.y)

  self.grid = {}
  for i = 0, self.size.x-1 do
    self.grid[i] = {}
    for j = 0, self.size.y-1 do
      local cell = Cell()
      cell:insert_into(self, i, j)
      self.grid[i][j] = cell
    end
  end

  self.color = Piece.RED
  return self
end

-------------------------------------------------------------------------------
function Board:position_default()
  for x = 0, self.size.x-1 do
    self:put(Piece(Piece.RED), Pos(x, 0))
    self:put(Piece(Piece.RED), Pos(x, 1))
    self:put(Piece(Piece.BLACK), Pos(x, self.size.y - 1))
    self:put(Piece(Piece.BLACK), Pos(x, self.size.y - 2))
  end
end

-------------------------------------------------------------------------------
function Board:put(piece, pos)
  print("Board:put "..tostring(piece).." at "..tostring(pos))
  assert(Pos(0, 0) <= pos and pos < self.size)
  self.grid[pos.x][pos.y].piece = piece
  piece:insert_into(self, pos)
end

-------------------------------------------------------------------------------
function Board:at(pos)
  return self.grid[pos.x][pos.y].piece  -- peek piece from cell by position
end

-------------------------------------------------------------------------------
-- Check if piece can move from one position to another
function Board:can_move(fr, to)
  -- check move rights
  local actor = self:at(fr)             -- peek piece at from position
  if actor == nil then                  -- check if it exists
    return false                        -- can not move
  end
  if actor.color ~= self.color then     -- check color who moves now
    return false                        -- can not move
  end

  -- check move ability
  local vec = actor.pos - to            -- movement vector
  local dist = vec:length2()            -- calculate square distance
  if dist < 1 or dist > 2 then          -- it cannot be too long
    return false                        -- can not move
  end

  -- check kill ability
  local victim = self:at(to)            -- peek piece at to position
  if victim then
    if victim.color == actor.color then -- can not kill piece of the same breed
      return false
    end
  end

  return true
end

-------------------------------------------------------------------------------
function Board:move(fr, to)
  -- take actor piece
  local actor = self:at(fr)             -- get piece at from position
  self.grid[fr.x][fr.y].piece = nil     -- erase piece from previous cell

  -- kill victim
  local victim = self:at(to)            -- peek possible victim at to position
  if victim then
    victim:die()
    victim = nil
  end

  -- assign actor piece to new position
  self.grid[to.x][to.y].piece = actor   -- set piece to new cell
  actor:move(to)                        -- move piece to new position

  -- next player move
  self.color = not self.color           -- switch to another player
end

return Board