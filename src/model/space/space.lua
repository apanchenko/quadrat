local spot      = require 'src.model.spot.spot'
local playerid  = require 'src.model.playerid'
local cfg       = require 'src.model.cfg'
local evt       = require 'src.lua-cor.evt'
local vec       = require 'src.lua-cor.vec'
local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('mode')
local obj       = require 'src.lua-cor.obj'
local typ       = require 'src.lua-cor.typ'
local wrp       = require 'src.lua-cor.wrp'
local arr       = require 'src.lua-cor.arr'

local space = obj:extend('space')

-------------------------------------------------------------------------------
-- create model ready to play
function space:new(cols, rows, seed)
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
    own_evt = evt:new(), -- owner events - full information
    opp_evt = evt:new() -- events from opponent - hidden information
  })

  -- fill grid
  for x = 0, cols - 1 do
    for y = 0, rows - 1 do
      self.grid[x * cols + y] = spot:new(x, y, self)
    end
  end

  return self
end
--
function space:width()      return self.cols end
--
function space:height()     return self.rows end
--
function space:row(place)   return place % self.cols end
-- place // self.cols
function space:col(place)   return (place - (place % self.cols)) / self.cols end

-- send private event
function space:whisper(event, ...)
  ass.is(self, space)
  ass(typ.str(event))
  log.info('space:notify_own', event, ...)
  self.own_evt:call(event, ...)
end

-- send public event
function space:yell_wrap_before(event, ...)
  ass.is(self, space)
  ass.is(typ.str(event))
end
function space:yell(event, ...)
  log.info('space:yell', event, ...)
  self.own_evt:call(event, ...)
  self.opp_evt:call(event, ...)
end

-- GRID------------------------------------------------------------------------
-- initial pieces placement
function space:setup()
  for x = 0, self.cols - 1 do
    self:spot(vec(x, 0            )):spawn_piece(playerid.white)
    self:spot(vec(x, 1            )):spawn_piece(playerid.white)
    self:spot(vec(x, self.rows - 1)):spawn_piece(playerid.black)
    self:spot(vec(x, self.rows - 2)):spawn_piece(playerid.black)
  end
  self:yell('move', self.pid) -- notify color to move
end
-- position vector from grid index
function space:pos(index)   return vec(self:col(index), self:row(index)) end
-- index of cell and piece, private
function space:index(vec)   return vec.x * self.cols + vec.y end
-- iterate cells
function space:spots()      return pairs(self.grid) end
-- get spot by position vector
function space:spot(vec)    return self.grid[self:index(vec)] end
-- select spots array
function space:select_spots(filter)
  local selected = arr()
  self:each_spot(function(spot)
    if filter(spot) then
      selected:push(spot)
    end
  end)
  return selected
end
--
function space:each_spot(fn)
  for i = 0, #self.grid do
    fn(self.grid[i])
  end
end
--
function space:each_piece(fn)
  self:each_spot(function(spot)
    local piece = spot.piece
    if piece then
      fn(piece)
    end
  end)
end

-- PIECES----------------------------------------------------------------------
-- get piece by position vector
function space:piece(vec)
  local spot = self:spot(vec)
  if spot then
    return spot.piece
  end
  return nil
end
-- number of red pieces, number of black pieces
function space:count_pieces()
  local res = {}
  res[tostring(playerid.white)] = 0
  res[tostring(playerid.black)] = 0

  self:each_spot(function(spot)
    local piece = spot.piece
    if piece then
      local idx = tostring(piece.pid)
      res[idx] = res[idx] + 1
    end
  end)
  return res
end


-- MOVE------------------------------------------------------------------------
-- get color to move
function space:who_move()   return self.pid end

-- check if piece can move from one position to another
function space:can_move(fr, to)
  if not (fr < self.size and to < self.size and vec.zero <= fr and vec.zero <= to) then
    return false;
  end

  -- check move rights
  local actor = self:piece(fr)        -- peek piece at from position
  if actor == nil then                      -- check if it exists
    log.trace(self, ':can_move from', fr, 'piece is nil')
    return false                            -- can not move
  end
  if self:who_move() ~= actor.pid then         -- check color who moves now
    log.trace(self, ":can_move, wrong color")
    return false                            -- can not move
  end

  -- check move ability
  if not self:spot(to):can_set_piece() then
    return false
  end
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
function space:move(fr, to)
  ass(self:can_move(fr, to))

  -- change piece position
  self:spot(to):move_piece(self:spot(fr))

  -- change current move color
  self.pid = self.pid:swap() -- invert color
  self.move_count = self.move_count + 1 -- increment moves count

  -- randomly spawn jades
  if (self.move_count % cfg.jade.moves) == 0 then
    self:select_spots(function(spot) return spot:can_set_jade() end)
        :random_sample(cfg.jade.spawn_count)
        :each(function(spot) spot:spawn_jade() end)
  end

  self:yell('move', self.pid) -- notify color to move
end

-- use ability
function space:use(pos, ability_name)
  -- check rights
  local piece = self:piece(pos)        -- peek piece at from position
  if piece == nil then                      -- check if it exists
    log.trace(self, ':use at ', pos, ' piece is nil')
    return false                            -- can not move
  end
  if self:who_move() ~= piece.pid then         -- check color who moves now
    log.trace(self, ":can_move, wrong color")
    return false                            -- can not move
  end
  return piece:use_jade(ability_name)
end

-- MODULE ---------------------------------------------------------------------
-- wrap functions
function space:wrap()
  local sis   = {'space', typ.new_is(space)}
  local sex   = {'space', typ.new_ex(space)}

   --wrp.fn(space, 'notify',   {{'method', typ.str}, {}})
  wrp.fn(log.trace, space, 'setup', {'space', typ.meta(space)})
  wrp.fn(log.info, space, 'width',        sex)
  wrp.fn(log.info, space, 'height',       sex)
  wrp.fn(log.trace, space, 'row',         sex,  {'place', typ.num})
  wrp.fn(log.info, space, 'col',          sex,  {'place', typ.num})
  wrp.fn(log.info, space, 'pos',          sex,  {'index', typ.num})
  wrp.fn(log.info, space, 'index',        sex,  {'vec', vec})
  wrp.fn(log.info, space, 'spot',         sex,  {'pos', vec})
  wrp.fn(log.info, space, 'each_piece',   sex,  {'fn', typ.fun})
  wrp.fn(log.info, space, 'each_spot',    sex,  {'fn', typ.fun})
  wrp.fn(log.info, space, 'count_pieces', sex)
  wrp.fn(log.info, space, 'piece',        sex,  {'pos', vec})
  wrp.fn(log.info, space, 'who_move',     sex)
  wrp.fn(log.info, space, 'can_move',     sex,  {'from', vec}, {'to', vec})
  wrp.fn(log.trace, space, 'move',        sex,  {'from', vec}, {'to', vec})
  wrp.fn(log.trace, space, 'use',         sex,  {'pos', vec}, {'ability_name', typ.str})
end

-- return module
return space