local map       = require 'src.lua-cor.map'
local ass       = require 'src.lua-cor.ass'
local log       = require 'src.lua-cor.log'
local vec       = require 'src.lua-cor.vec'
local obj       = require 'src.lua-cor.obj'
local env       = require 'src.lua-cor.env'
local wrp       = require 'src.lua-cor.wrp'
local typ       = require 'src.lua-cor.typ'
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