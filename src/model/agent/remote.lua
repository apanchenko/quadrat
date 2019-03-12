local map       = require 'src.core.map'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local vec       = require 'src.core.vec'
local obj       = require 'src.core.obj'
local wrp       = require 'src.core.wrp'
local playerid  = require 'src.model.playerid'

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
    local from = vec:random(vec.zero, self.space.size - vec.one)
    local piece = self.space:piece(from)
    if piece ~= nil and piece.pid == self.pid then
      -- execute random ability
      local jade = map.random(piece.jades)
      if jade then
        piece:use_jade(jade.id)
      end
      -- move to random point
      local to = from + vec:random(vec.zero-vec.one, vec.one)
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
--
function remote:wrap()
  wrp.fn(remote, 'move', {{'playerid'}})
  wrp.fn(remote, 'move_async', {})
end

return remote