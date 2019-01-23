local map       = require 'src.core.map'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Vec       = require 'src.core.vec'
local obj       = require 'src.core.obj'
local wrp       = require 'src.core.wrp'
local playerid  = require 'src.model.playerid'
local Ability   = require 'src.model.Ability'

--
local remote = obj:extend('remote')
remote.space = nil
remote.pid = nil

-- create
function remote:new(space, pid)
  return obj.new(self,
  {
    space = space,
    pid = pid
  })
end
--
function remote:__tostring()
  return 'remote['..tostring(self.pid)..']'
end
--
function remote:move(pid)
  if pid == self.pid then
    timer.performWithDelay(100, function() self:move_async() end)
  end
end
--
function remote:move_async()
  local attempts = 1000

  -- do something until can move
  while self.space:who_move() == self.pid do
    -- select random piece of my color
    local from = Vec:random(Vec.zero, self.space.size - Vec.one)
    local piece = self.space:piece(from)
    if piece ~= nil and piece.pid == self.pid then
      -- execute random ability
      local ability = map.random(piece.abilities)
      if ability then
        piece:use_ability(tostring(ability))
      end
      -- move to random point
      local to = from + Vec:random(Vec.zero-Vec.one, Vec.one)
      if self.space:can_move(from, to) then
        self.space:move(from, to)
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
wrp.fn(remote, 'move', {{'playerid'}})
wrp.fn(remote, 'move_async', {})

return remote