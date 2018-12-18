local Spot      = require 'src.model.Spot'
local Piece     = require 'src.model.Piece'
local playerid  = require 'src.model.playerid'
local Config    = require 'src.model.Config'
local evt       = require 'src.core.evt'
local Vec       = require 'src.core.vec'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Class     = require 'src.core.Class'
local typ     = require 'src.core.typ'

local Space = Class.Create 'Space'

-------------------------------------------------------------------------------
-- create model ready to play
function Space.New(cols, rows)
  ass.natural(cols)
  ass.natural(rows)

  local self = setmetatable({}, Space)
  self.cols  = cols    -- width
  self.rows  = rows    -- height
  self.size  = Vec(cols, rows)
  self.grid  = {}      -- cells
  self.pid   = playerid.white -- who moves now
  self.move_count = 0 -- number of moves from start
  self.on_change = evt:create()
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

--
function Space:notify(method, ...)
  ass.is(self, Space)
  ass.is(method, typ.str)
  self.on_change:call(method, ...) -- notify
end

-- GRID------------------------------------------------------------------------
-- initial pieces placement
function Space:setup()
  for x = 0, self.cols - 1 do
    self.grid[x * self.cols]:spawn_piece(playerid.white)
    self.grid[x * self.cols + self.rows - 1]:spawn_piece(playerid.black)
  end
  self:notify('move', self.pid) -- notify color to move
end
-- position vector from grid index
function Space:pos(index)   return Vec(self:col(index), self:row(index)) end
-- index of cell and piece, private
function Space:index(vec)   return vec.x * self.cols + vec.y end
-- iterate cells
function Space:spots()      return pairs(self.grid) end
-- get spot by position vector
function Space:spot(vec)    return self.grid[self:index(vec)] end
--
function Space:select_spots(filter)
  local selected = {}
  for k, spot in ipairs(self.grid) do
    if filter(spot) then
      selected[#selected + 1] = spot
    end
	end
  return selected
end

-- PIECES----------------------------------------------------------------------
-- get piece by position vector
function Space:piece(vec)
  local spot = self:spot(vec)
  if spot then
    return spot.piece
  end
  return nil
end
-- number of red pieces, number of black pieces
function Space:count_pieces()
  local red = 0
  local bla = 0
  for i = 0, #self.grid do -- pics is not dense, so use # on grid
    local piece = self.grid[i].piece
    if piece then
      if piece.pid == playerid.white then
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
function Space:who_move()   return self.pid end

-- check if piece can move from one position to another
function Space:can_move(fr, to)
  if not (fr < self.size and to < self.size and Vec.zero <= fr and Vec.zero <= to) then
    return false;
  end

  -- check move rights
  local actor = self:piece(fr)        -- peek piece at from position
  if actor == nil then                      -- check if it exists
    log:trace(self, ':can_move from', fr, 'piece is nil')
    return false                            -- can not move
  end
  if self:who_move() ~= actor.pid then         -- check color who moves now
    log:trace(self, ":can_move, wrong color")
    return false                            -- can not move
  end

  -- check move ability
  if not actor:can_move(fr, to) then
    return false
  end

  -- check kill ability
  local victim = self:piece(to)               -- peek piece at to position
  if victim and (victim.pid == actor.pid or victim:is_jump_protected()) then
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
  self.pid = self.pid:swap() -- invert color
  self.move_count = self.move_count + 1 -- increment moves count

  -- randomly spawn jades
  if (self.move_count % Config.jade.moves) == 0 then
    for i = 0, #self.grid do -- pics is not dense, so use # on grid
      self.grid[i]:spawn_jade()
    end
  end

  self:notify('move', self.pid) -- notify color to move
end

-- use ability
function Space:use(pos, ability_name)
  -- check rights
  local piece = self:piece(pos)        -- peek piece at from position
  if piece == nil then                      -- check if it exists
    log:trace(self, ':use at ', pos, ' piece is nil')
    return false                            -- can not move
  end
  if self:who_move() ~= piece.pid then         -- check color who moves now
    log:trace(self, ":can_move, wrong color")
    return false                            -- can not move
  end
  return piece:use_ability(ability_name)
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(Space, ':setup')
ass.wrap(Space, ':pos', typ.num)
ass.wrap(Space, ':width')
ass.wrap(Space, ':height')
ass.wrap(Space, ':row', typ.num)
ass.wrap(Space, ':col', typ.num)
ass.wrap(Space, ':pos', typ.num)
ass.wrap(Space, ':index', Vec)
ass.wrap(Space, ':spots')
ass.wrap(Space, ':spot', Vec)
ass.wrap(Space, ':count_pieces')
ass.wrap(Space, ':piece', Vec)
ass.wrap(Space, ':who_move')
ass.wrap(Space, ':can_move', Vec, Vec)
ass.wrap(Space, ':move', Vec, Vec)
ass.wrap(Space, ':use', Vec, typ.str)

log:wrap(Space, 'setup', 'move', 'use')

-- return module
return Space