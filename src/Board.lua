local Cell = require("src.Cell")
local Piece = require("src.Piece")
local Pos = require("src.Pos")
local Player = require("src.Player")

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
-- player color who moves now
function Board.new(width, height, battle)
  local self = setmetatable({}, Board)
  self.size = Pos(width or 8, height or 8)
  self.battle = battle

  local scale = display.contentWidth / (8 * Cell.size.x);
  self.scale = Pos(scale, scale)        -- 2D scale
  self.group = display.newGroup()       -- disply group
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
  return self
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
function Board:put(color, to)
  assert(Pos(0, 0) <= to)               -- check to position is on board
  assert(to < self.size)
  local piece = Piece(color)            -- create a new piece
  self.grid[to.x][to.y].piece = piece   -- assign to cell
  piece:puton(self, to)                 -- put piece on board
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
  if vec.x ~= 0 and vec.y ~= 0 then     -- allow orthogonal move only
    return false
  end
  if vec:length2() ~= 1 then            -- allow move one cell at a time
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

  -- notify battle about player moved
  self.battle:onMoved(self.color)
end

-------------------------------------------------------------------------------
function Board:count_pieces()
  --assert(type(color) == type(Player.Red), "Wrong color type")
  local red = 0
  local bla = 0
  for i = 0, self.size.x - 1 do
    for j = 0, self.size.y - 1 do
      local piece = self:at(Pos(i, j))
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

return Board