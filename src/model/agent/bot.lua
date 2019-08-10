local log       = require('src.lua-cor.log').get('mode')
local vec       = require 'src.lua-cor.vec'
local obj       = require 'src.lua-cor.obj'
local wrp       = require 'src.lua-cor.wrp'
local typ       = require 'src.lua-cor.typ'
local com         = require 'src.lua-cor.com'

--
local bot = obj:extend('bot')
random.space = nil
random.pid = nil

-- create
function random:new(env, pid)
  self = obj.new(self, com())
  self.env = env
  self.pid = pid
  return self
end
-- listen space
function random:on_space(space)
  space.own_evt.add(self)
end
--
function random:__tostring()
  return 'random_player{'..tostring(self.pid)..'}'
end
--
function random:move(pid)
  if pid == self.pid then
    timer.performWithDelay(100, function() self:move_async() end)
  end
end
--
function random:move_async()
  local attempts = 1000
  local space = self.env.space
  -- do something until can move
  while space:who_move() == self.pid do
    -- select random piece of my color
    local from = vec:random(vec.zero, space.size - vec.one)
    local piece = space:piece(from)
    if piece ~= nil and piece.pid == self.pid then
      -- execute random ability
      local jade = piece.jades:random()
      if jade then
        piece:use_jade(jade.id)
      end
      -- move to random point
      local to = from + vec:random(vec.zero-vec.one, vec.one)
      if space:can_move(from, to) then
        space:move(from, to)
      end
    end

    attempts = attempts - 1
    if attempts <= 0 then
      log.trace('cannot find move')
      break
    end
  end
end

-- MODULE ---------------------------------------------------------------------
--
function random:wrap()
  local is   = {'random', typ.new_is(random)}
  local ex    = {'exrandom', typ.new_ex(random)}

  wrp.fn(log.trace, random, 'new',        is, {'env', typ.any}, {'playerid'})
  wrp.fn(log.info, random, 'move',        ex, {'playerid'})
  wrp.fn(log.trace, random, 'move_async', ex)
end

return random