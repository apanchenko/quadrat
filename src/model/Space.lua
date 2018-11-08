local Spot      = require 'src.model.Spot'
local Piece     = require 'src.model.Piece'
local Color     = require 'src.model.Color'
local Config    = require 'src.model.Config'
local Event     = require 'src.core.Event'
local Vec       = require 'src.core.Vec'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'

local Space = setmetatable({}, { __tostring = function() return 'Space' end })
Space.__index = Space

-------------------------------------------------------------------------------
-- create model ready to play
function Space.new(cols, rows)
  ass.Natural(cols)
  ass.Natural(rows)

  local self = setmetatable({}, Space)
  self.cols  = cols    -- width
  self.rows  = rows    -- height
  self.grid  = {}      -- cells
  self.color = Color.red(true) -- who moves now
  self.move_count = 0 -- number of moves from start
  self.on_change = Event.new()
  log:trace(self, '.new')

  -- fill grid
  for x = 0, cols - 1 do
    for y = 0, rows - 1 do
      self.grid[x * cols + y] = Spot.new(x, y, self)
    end
  end

  return self
end

--
function Space:__tostring() return 'space' end
--
function Space:width()      return self.cols end
--
function Space:height()     return self.rows end
--
function Space:row(place)   return place % self.cols end
-- place // self.cols
function Space:col(place)   return (place - (place % self.cols)) / self.cols end

-- GRID------------------------------------------------------------------------
-- initial pieces placement
function Space:setup()
  for x = 0, self.cols - 1 do
    self.grid[x * self.cols]:spawn_piece(Color.R)
    self.grid[x * self.cols + self.rows - 1]:spawn_piece(Color.B)
  end
end

-- position vector from grid index
function Space:pos(index)
  ass.Number(index)
  return Vec(self:col(index), self:row(index))
end

-- index of cell and piece, private
function Space:index(vec)   return vec.x * self.cols + vec.y end

-- iterate cells
function Space:spots()      return pairs(self.grid) end

-- get spot by position vector
function Space:spot(vec)    return self.grid[self:index(vec)] end

-- PIECES----------------------------------------------------------------------
-- get piece by position vector
function Space:piece(vec)
  ass.Is(vec, Vec)
  local spot = self:spot(vec)
  if spot then
    return spot:piece()
  end
  return nil
end

-- number of red pieces, number of black pieces
function Space:count_pieces()
  local red = 0
  local bla = 0
  for i = 0, #self.grid do -- pics is not dense, so use # on grid
    local piece = self.grid[i]:piece()
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

-- check if piece can move from one position to another
function Space:can_move(fr, to)
  -- check move rights
  local actor = self:piece(fr)        -- peek piece at from position
  if actor == nil then                      -- check if it exists
    log:trace(self, ':can_move from', fr, 'piece is nil')
    return false                            -- can not move
  end
  if self:who_move() ~= actor:color() then         -- check color who moves now
    log:trace(self, ":can_move, wrong color")
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
  ass(self:can_move(fr, to))

  -- change piece position
  self:spot(to):move_piece(self:spot(fr))

  -- change current move color
  self.color = Color.swap(self.color) -- invert color
  self.move_count = self.move_count + 1 -- increment moves count

  -- randomly spawn jades
  if (self.move_count % Config.jade.moves) == 0 then
    for i = 0, #self.grid do -- pics is not dense, so use # on grid
      self.grid[i]:spawn_jade()
    end
  end

  self.on_change:call('move', self.color) -- notify color to move
end

-------------------------------------------------------------------------------
-- true if valid
function Space:valid()
  return true
end

ass.Wrap(Space, 'setup')
ass.Wrap(Space, 'width')
ass.Wrap(Space, 'height')
ass.Wrap(Space, 'row', 'number')
ass.Wrap(Space, 'col', 'number')
ass.Wrap(Space, 'pos', 'number')
ass.Wrap(Space, 'index', Vec)
ass.Wrap(Space, 'spots')
ass.Wrap(Space, 'spot', Vec)
ass.Wrap(Space, 'count_pieces')
ass.Wrap(Space, 'piece', Vec)
ass.Wrap(Space, 'who_move')
ass.Wrap(Space, 'can_move', Vec, Vec)
ass.Wrap(Space, 'move', Vec, Vec)

log:wrap(Space, 'setup', 'move')

-- return module
return Space