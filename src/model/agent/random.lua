local map       = require 'src.luacor.map'
local ass       = require 'src.luacor.ass'
local log       = require 'src.luacor.log'
local vec       = require 'src.luacor.vec'
local obj       = require 'src.luacor.obj'
local env       = require 'src.luacor.env'
local wrp       = require 'src.luacor.wrp'
local typ       = require 'src.luacor.typ'
local playerid  = require 'src.model.playerid'

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
  space.own_evt:add(self)
end
--
function random:__tostring()
  return 'random_player{'..tostring(self.pid)..'}'
end
--
function random:move(pid)
  if pid == self.pid then
    timer.performWithDelay(20, function() self:move_async() end)
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
      log:trace('cannot find move')
      break
    end
  end
end

-- MODULE ---------------------------------------------------------------------
--
function random:wrap()
  wrp.wrap_tbl_trc(random, 'new',       {'env', typ.any}, {'playerid'})
  wrp.wrap_sub_inf(random, 'move',      {'playerid'})
  wrp.wrap_sub_trc(random, 'move_async')
end

return random