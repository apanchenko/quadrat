local map       = require 'src.core.map'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Vec       = require 'src.core.vec'
local obj       = require 'src.core.obj'
local env       = require 'src.core.env'
local wrp       = require 'src.core.wrp'
local typ       = require 'src.core.typ'
local playerid  = require 'src.model.playerid'
local Ability   = require 'src.model.Ability'

--
local random = obj:extend('random')
random.space = nil
random.pid = nil

-- create
function random:new(env, pid)
  self = obj.new(self,
  {
    env = env,
    pid = pid
  })
  return self
end
-- listen space
function random:on_space(space)
  space.on_change:add(self)
end
--
function random:__tostring()
  return 'player.random['..tostring(self.pid)..']'
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
    local from = Vec:random(Vec.zero, space.size - Vec.one)
    local piece = space:piece(from)
    if piece ~= nil and piece.pid == self.pid then
      -- execute random ability
      local ability = map.random(piece.abilities)
      if ability then
        piece:use_ability(tostring(ability))
      end
      -- move to random point
      local to = from + Vec:random(Vec.zero-Vec.one, Vec.one)
      if space:can_move(from, to) then
        space:move(from, to)
      end
    end

    attempts = attempts - 1
    if attempts <= 0 then
      log:trace('cannot find move')
      break
    end
  end
end

-- MODULE ---------------------------------------------------------------------
wrp.fn(random, 'new', {{'env', typ.any}, {'playerid'}}) -- env?
wrp.fn(random, 'move', {{'playerid'}})
wrp.fn(random, 'move_async')

return random