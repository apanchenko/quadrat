local spot      = require 'src.model.spot.spot'
local playerid  = require 'src.model.playerid'
local cfg       = require 'src.model.cfg'
local vec       = require('src.lua-cor.vec')
local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('mode')
local obj       = require('src.lua-cor.obj')
local typ       = require('src.lua-cor.typ')
local wrp       = require('src.lua-cor.wrp')
local arr       = require 'src.lua-cor.arr'
local bro       = require('src.lua-cor.bro')

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
    move_count    = 0, -- number of moves from start
    set_move      = bro('set_move'), -- delegate
    set_ability   = bro('set_ability'), -- delegate
    set_color     = bro('set_color'), -- delegate
    add_power     = bro('add_power'), -- delegate
    remove_power  = bro('remove_power'), -- delegate
    spawn_piece   = bro('spawn_piece'), -- delegate
    move_piece    = bro('move_piece'), -- delegate
    remove_piece  = bro('remove_piece'), -- delegate
    stash_piece   = bro('stash_piece'), -- delegate
    unstash_piece = bro('unstash_piece'), -- delegate
    spawn_jade    = bro('spawn_jade'), -- delegate
    stash_jade    = bro('stash_jade'), -- delegate
    unstash_jade  = bro('unstash_jade'), -- delegate
    remove_jade   = bro('remove_jade'), -- delegate
    modify_spot   = bro('modify_spot'), -- delegate
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

-- EVENTS------------------------------------------------------------------------
function space:listen(listener, name, subscribe)
  self[name]:listen(listener, subscribe)
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
  self.set_move(self.pid) -- notify
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

--
function space:each_piece(fn)
  self:each_spot(function(spot)
    local piece = spot.piece
    if piece then
      fn(piece)
    end
  end)
end

-- MOVE------------------------------------------------------------------------
-- get color to move
function space:get_move_pid()   return self.pid end

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
  if self:get_move_pid() ~= actor.pid then         -- check color who moves now
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

  self.set_move(self.pid) -- notify
end

-- use ability
function space:use(pos, ability_name)
  -- check rights
  local piece = self:piece(pos)        -- peek piece at from position
  if piece == nil then                      -- check if it exists
    log.trace(self, ':use at ', pos, ' piece is nil')
    return false                            -- can not move
  end
  if self:get_move_pid() ~= piece.pid then         -- check color who moves now
    log.trace(self, ":can_move, wrong color")
    return false                            -- can not move
  end
  return piece:use_jade(ability_name)
end

-- MODULE ---------------------------------------------------------------------
-- wrap functions
function space:wrap()
  local ex   = typ.new_ex(space)

   --wrp.fn(space, 'notify',   {{'method', typ.str}, {}})
  wrp.fn(log.trace, space, 'setup',       space)
  wrp.fn(log.info, space, 'width',        ex)
  wrp.fn(log.info, space, 'height',       ex)
  wrp.fn(log.trace, space, 'row',         ex,  typ.num)
  wrp.fn(log.info, space, 'col',          ex,  typ.num)
  wrp.fn(log.info, space, 'pos',          ex,  typ.num)
  wrp.fn(log.info, space, 'index',        ex,  vec)
  wrp.fn(log.info, space, 'spot',         ex,  vec)
  wrp.fn(log.info, space, 'each_piece',   ex,  typ.fun)
  wrp.fn(log.info, space, 'each_spot',    ex,  typ.fun)
  wrp.fn(log.info, space, 'count_pieces', ex)
  wrp.fn(log.info, space, 'piece',        ex,  vec)
  wrp.fn(log.info, space, 'get_move_pid', ex)
  wrp.fn(log.info, space, 'can_move',     ex,  vec, vec)
  wrp.fn(log.trace, space, 'move',        ex,  vec, vec)
  wrp.fn(log.trace, space, 'use',         ex,  vec, typ.str)
  wrp.fn(log.trace, space, 'listen',      ex,  typ.tab, typ.str, typ.boo)
end

-- return module
return space