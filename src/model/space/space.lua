local spot      = require('src.model.spot.spot')
local playerid  = require('src.model.playerid')
local cfg       = require('src.model.cfg')
local vec       = require('src.lua-cor.vec')
local ass       = require('src.lua-cor.ass')
local log       = require('src.lua-cor.log').get('mode')
local typ       = require('src.lua-cor.typ')
local wrp       = require('src.lua-cor.wrp')
local arr       = require('src.lua-cor.arr')
local Wind      = require('src.model.space.wind')

local Space = Wind:extend('Space')

-------------------------------------------------------------------------------
-- create model ready to play
function Space:new(cols, rows, seed)
  ass.nat(cols)
  ass.nat(rows)
  self = Wind.new(self)
  self.cols  = cols    -- width
  self.rows  = rows    -- height
  self.size  = vec(cols, rows)
  self.grid  = {}      -- cells
  self.pid   = playerid.white -- who moves now
  self.move_count = 0 -- number of moves from start

  -- fill grid
  for x = 0, cols - 1 do
    for y = 0, rows - 1 do
      self.grid[x * cols + y] = spot:new(x, y, self)
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

-- GRID------------------------------------------------------------------------
-- initial pieces placement
function Space:setup()
  for x = 0, self.cols - 1 do
    self:spot(vec(x, 0            )):spawn_piece(playerid.white)
    self:spot(vec(x, 1            )):spawn_piece(playerid.white)
    self:spot(vec(x, self.rows - 1)):spawn_piece(playerid.black)
    self:spot(vec(x, self.rows - 2)):spawn_piece(playerid.black)
  end
  self.on_set_move(self.pid) -- notify
end
-- position vector from grid index
function Space:pos(index)   return vec(self:col(index), self:row(index)) end
-- index of cell and piece, private
function Space:index(vec)   return vec.x * self.cols + vec.y end
-- iterate cells
function Space:spots()      return pairs(self.grid) end
-- get spot by position vector
function Space:spot(vec)    return self.grid[self:index(vec)] end
-- select spots array
function Space:select_spots(filter)
  local selected = arr()
  self:each_spot(function(spot)
    if filter(spot) then
      selected:push(spot)
    end
  end)
  return selected
end
--
function Space:each_spot(fn)
  for i = 0, #self.grid do
    fn(self.grid[i])
  end
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
function Space:each_piece(fn)
  self:each_spot(function(spot)
    local piece = spot.piece
    if piece then
      fn(piece)
    end
  end)
end

-- MOVE------------------------------------------------------------------------
-- get color to move
function Space:get_move_pid()   return self.pid end

-- check if piece can move from one position to another
function Space:can_move(fr, to)
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
function Space:move(fr, to)
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

  self.on_set_move(self.pid) -- notify
end

-- use ability
function Space:use(pos, ability_name)
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
function Space:wrap()
  local ex   = typ.new_ex(Space)

   --wrp.fn(Space, 'notify',   {{'method', typ.str}, {}})
  wrp.fn(log.trace, Space, 'setup',       Space)
  wrp.fn(log.info, Space, 'width',        ex)
  wrp.fn(log.info, Space, 'height',       ex)
  wrp.fn(log.trace, Space, 'row',         ex,  typ.num)
  wrp.fn(log.info, Space, 'col',          ex,  typ.num)
  wrp.fn(log.info, Space, 'pos',          ex,  typ.num)
  wrp.fn(log.info, Space, 'index',        ex,  vec)
  wrp.fn(log.info, Space, 'spot',         ex,  vec)
  wrp.fn(log.info, Space, 'each_piece',   ex,  typ.fun)
  wrp.fn(log.info, Space, 'each_spot',    ex,  typ.fun)
  wrp.fn(log.info, Space, 'count_pieces', ex)
  wrp.fn(log.info, Space, 'piece',        ex,  vec)
  wrp.fn(log.info, Space, 'get_move_pid', ex)
  wrp.fn(log.info, Space, 'can_move',     ex,  vec, vec)
  wrp.fn(log.trace, Space, 'move',        ex,  vec, vec)
  wrp.fn(log.trace, Space, 'use',         ex,  vec, typ.str)
  wrp.fn(log.trace, Space, 'listen',      ex,  typ.tab, typ.str, typ.boo)
end

-- return module
return Space