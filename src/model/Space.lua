local Spot      = require 'src.model.Spot'
local Piece     = require 'src.model.Piece'
local Color     = require 'src.model.Color'
local Config    = require 'src.model.Config'
local Event     = require 'src.core.Event'
local Vec       = require 'src.core.Vec'
local Ass       = require 'src.core.Ass'
local log       = require 'src.core.log'
local Type      = require 'src.core.Type'

local Space = Type.Create 'Space'

-------------------------------------------------------------------------------
-- create model ready to play
function Space.New(cols, rows)
  Ass.Natural(cols)
  Ass.Natural(rows)

  local self = setmetatable({}, Space)
  self.cols  = cols    -- width
  self.rows  = rows    -- height
  self.grid  = {}      -- cells
  self.color = Color.red(true) -- who moves now
  self.move_count = 0 -- number of moves from start
  self.on_change = Event.New()
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
function Space:pos(index)   return Vec(self:col(index), self:row(index)) end
-- index of cell and piece, private
function Space:index(vec)   return vec.x * self.cols + vec.y end
-- iterate cells
function Space:spots()      return pairs(self.grid) end
-- get spot by position vector
function Space:spot(vec)    return self.grid[self:index(vec)] end

-- PIECES----------------------------------------------------------------------
-- get piece by position vector
function Space:piece(vec)
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
function Space:who_move()   return self.color end

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
  Ass(self:can_move(fr, to))

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

-- use ability
function Space:use(pos, ability_name)
  -- check rights
  local piece = self:piece(pos)        -- peek piece at from position
  if piece == nil then                      -- check if it exists
    log:trace(self, ':use at ', pos, ' piece is nil')
    return false                            -- can not move
  end
  if self:who_move() ~= piece:color() then         -- check color who moves now
    log:trace(self, ":can_move, wrong color")
    return false                            -- can not move
  end
  return piece:use_ability(ability_name)
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Space, 'setup')
Ass.Wrap(Space, 'pos', 'number')
Ass.Wrap(Space, 'width')
Ass.Wrap(Space, 'height')
Ass.Wrap(Space, 'row', 'number')
Ass.Wrap(Space, 'col', 'number')
Ass.Wrap(Space, 'pos', 'number')
Ass.Wrap(Space, 'index', Vec)
Ass.Wrap(Space, 'spots')
Ass.Wrap(Space, 'spot', Vec)
Ass.Wrap(Space, 'count_pieces')
Ass.Wrap(Space, 'piece', Vec)
Ass.Wrap(Space, 'who_move')
Ass.Wrap(Space, 'can_move', Vec, Vec)
Ass.Wrap(Space, 'move', Vec, Vec)
Ass.Wrap(Space, 'use', Vec, 'string')

log:wrap(Space, 'setup', 'move', 'use')

-- return module
return Space