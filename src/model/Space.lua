local Spot      = require 'src.model.Spot'
local Piece     = require 'src.model.Piece'
local playerid  = require 'src.model.playerid'
local cfg       = require 'src.model.cfg'
local evt       = require 'src.core.evt'
local vec       = require 'src.core.vec'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local obj       = require 'src.core.obj'
local typ       = require 'src.core.typ'
local wrp       = require 'src.core.wrp'

local Space = obj:extend('Space')

-------------------------------------------------------------------------------
-- create model ready to play
function Space:new(cols, rows, seed)
  ass.nat(cols)
  ass.nat(rows)
  self = obj.new(self,
  {
    cols  = cols,    -- width
    rows  = rows,    -- height
    size  = vec(cols, rows),
    grid  = {},      -- cells
    pid   = playerid.white, -- who moves now
    move_count = 0, -- number of moves from start
    on_change = evt:new()
  })

  -- fill grid
  for x = 0, cols - 1 do
    for y = 0, rows - 1 do
      self.grid[x * cols + y] = Spot:new(x, y, self)
    end
  end

  return self
end
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
  log:info('Space:notify', method, ...)
  -- break the stack
  --timer.performWithDelay(0, function() self.on_change:call(method, unpack(arg)) end)
  self.on_change:call(method, ...)
end

-- GRID------------------------------------------------------------------------
-- initial pieces placement
function Space:setup()
  for x = 0, self.cols - 1 do
    self:spot(vec(x, 0            )):spawn_piece(playerid.white)
    self:spot(vec(x, 1            )):spawn_piece(playerid.white)
    self:spot(vec(x, self.rows - 1)):spawn_piece(playerid.black)
    self:spot(vec(x, self.rows - 2)):spawn_piece(playerid.black)
  end
  self:notify('move', self.pid) -- notify color to move
end
-- position vector from grid index
function Space:pos(index)   return vec(self:col(index), self:row(index)) end
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
  local res = {}
  res[tostring(playerid.white)] = 0
  res[tostring(playerid.black)] = 0

  for i = 0, #self.grid do -- pics is not dense, so use # on grid
    local piece = self.grid[i].piece
    if piece then
      local idx = tostring(piece.pid)
      res[idx] = res[idx] + 1
    end
  end
  return res
end


-- MOVE------------------------------------------------------------------------
-- get color to move
function Space:who_move()   return self.pid end

-- check if piece can move from one position to another
function Space:can_move(fr, to)
  if not (fr < self.size and to < self.size and vec.zero <= fr and vec.zero <= to) then
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
  if (self.move_count % cfg.jade.moves) == 0 then
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
  return piece:use_jade(ability_name)
end

-- MODULE ---------------------------------------------------------------------
-- wrap vec functions
function Space.wrap()
  local info = {log = log.info}
  --wrp.fn(Space, 'notify',   {{'method', typ.str}, {}})
  wrp.fn(Space, 'setup',    {})
  wrp.fn(Space, 'pos',      {{'index', typ.num}})
  wrp.fn(Space, 'width',    {},                           info)
  wrp.fn(Space, 'height',   {})
  wrp.fn(Space, 'row',      {{'place', typ.num}})
  wrp.fn(Space, 'col',      {{'place', typ.num}})
  wrp.fn(Space, 'pos',      {{'index', typ.num}})
  wrp.fn(Space, 'index',    {{'vec', vec}},               info)
  wrp.fn(Space, 'spot',     {{'pos', vec}},               info)
  wrp.fn(Space, 'count_pieces', {},                       info)
  wrp.fn(Space, 'piece',    {{'pos', vec}},               info)
  wrp.fn(Space, 'who_move', {}, info)
  wrp.fn(Space, 'can_move', {{'from', vec}, {'to', vec}}, info)
  wrp.fn(Space, 'move',     {{'from', vec}, {'to', vec}})
  wrp.fn(Space, 'use',      {{'pos', vec}, {'ability_name', typ.str}})
end

-- return module
return Space