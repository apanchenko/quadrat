local Spot      = require 'src.model.Spot'
local Piece     = require 'src.model.Piece'
local Color     = require 'src.model.Color'
local Event     = require 'src.core.Event'
local Vec       = require 'src.core.vec'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'

local Space = {}
Space.typename = 'Space'
Space.__index = Space

-------------------------------------------------------------------------------
-- create model ready to play
function Space.new(cols, rows)
  ass.natural(cols)
  ass.natural(rows)

  -- create empty grid
  local grid = {}
  local pics = {}
  for x = 0, cols - 1 do
  for y = 0, rows - 1 do
    place = x * cols + y
    grid[place] = Spot.new()
    if y == 0 or y == rows-1 then
      pics[place] = Piece.new(Color.red(y == 0))
    end
  end
  end

  local self =
  {
    cols  = cols,    -- width
    rows  = rows,    -- height
    grid  = grid,    -- cells
    pics  = pics,    -- pieces
    color = Color.red(true), -- who moves now
    move_count = 0,  -- number of moves from start

    on_move = Event.new('on_move')
  }  
  return setmetatable(self, Space)
end

--
function Space:__tostring() return 'space' end
--
function Space:width()      return self.cols end
--
function Space:height()     return self.rows end
--
function Space:pieces()     return pairs(self.pics) end
--
function Space:row(place)   return place % self.cols end
-- place // self.cols
function Space:col(place)   return (place - (place % self.cols)) / self.cols end

-- GRID------------------------------------------------------------------------
-- iterate cells
function Space:spots()
  return pairs(self.grid)
end

-- position vector from grid index
function Space:pos(index)
  ass.number(index)
  return Vec(self:col(index), self:row(index))
end

-- index of cell and piece, private
function Space:index(vec)
  ass.is(vec, Vec)
  return vec.x * self.cols + vec.y
end

-- get spot by position vector
function Space:spot(vec)
  ass.is(vec, Vec)
  return self.grid[self:index(vec)]
end

-- PIECES----------------------------------------------------------------------
-- get piece by position vector
function Space:piece(vec)
  ass.is(vec, Vec)
  return self.pics[self:index(vec)]
end

-- number of red pieces, number of black pieces
function Space:get_piece_count()
  local red = 0
  local bla = 0
  for i = 0, #self.grid do -- pics is not dense, so use # on grid
    local piece = self.pics[i]
    if piece then
      if Color.is_red(piece:color()) then
        red = red + 1
      else
        bla = bla + 1
      end
    end
  end
  return red, bla
end

-- MOVE------------------------------------------------------------------------
-- get color to move
function Space:who_move()
  return self.color
end

-- is color moves
function Space:is_move(color)
  Color.ass(color)
  return self.color == color
end

-- check if piece can move from one position to another
function Space:can_move(fr, to)
  ass.is(fr, Vec)
  ass.is(to, Vec)

  -- check move rights
  local actor = self:piece(fr)        -- peek piece at from position
  if actor == nil then                      -- check if it exists
    log:trace(self, "can_move, actor is nil")
    return false                            -- can not move
  end
  if not self:is_move(actor:color()) then         -- check color who moves now
    log:trace(self, "can_move, wrong color")
    return false                            -- can not move
  end

  -- check move ability
  if not actor:can_move(self, fr, to) then
    return false
  end

  -- check kill ability
  local victim = self:piece(to)               -- peek piece at to position
  if victim and not actor:can_jump(victim) then
    return false
  end

  return true
end

-- do move
function Space:move(fr, to)
  ass.is(fr, Vec)
  ass.is(to, Vec)
  ass(self:can_move(fr, to))
  local depth = log:trace(self, ':move ', fr, ' -> ', to):enter()

  -- change piece position
  local fr_index = self:index(fr)
  local to_index = self:index(to)
  local piece = self.pics[to_index]
  if piece then
    piece:die() -- kill piece on target spot
  end
  self.pics[to_index] = self.pics[fr_index] -- put piece onto target spot
  self.pics[fr_index] = nil -- make source spot empty

  -- change current move color
  self.color = Color.swap(self.color) -- invert color
  self.move_count = self.move_count + 1 -- increment moves count

  -- randomly spawn jades in cells
  for i = 0, #self.grid do -- pics is not dense, so use # on grid
    if self.pics[i] == nil then
      local spot = self.spots[i]
      if math.random() > jade_probability then
        return
      end
    end
    self:set_jade()
  end

  self.on_move() -- notify mode done
  log:exit(depth)
end

-- ----------------------------------------------------------------------------
-- true if valid
function Space:valid()
  return true
end

-- return module
return Space