local log       = require('src.lua-cor.log').get('mode')
local vec       = require('src.lua-cor.vec')
local obj       = require('src.lua-cor.obj')
local com       = require('src.lua-cor.com')

--
local random = obj:extend('random')

-- private
local _space = {}

-- constructor
function random:new(controller)
  self = obj.new(self, com())
  self[_space] = controller
  self[_space]:listen_set_move(self, true) -- todo unlisten
  return self
end

--
function random:__tostring()
  return 'agent_random{'..tostring(self[_space]:get_pid())..'}'
end

--
function random:set_move(pid)
  if self[_space]:is_my_move() then
    timer.performWithDelay(100, function() self:move_async() end)
  end
end

--
function random:move_async()
  local attempts = 1000
  local space = self[_space]
  -- do something until can move
  while space:is_my_move() do
    -- select random piece of my color
    local from = vec:random(vec.zero, space:get_size() - vec.one)
    local piece = space:get_piece(from)
    if piece and piece:is_friend() then
      -- fire jade
      local jadeid = piece:get_jades():random()
      if jadeid then
        piece:use_jade(jadeid)
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
  local wrp       = require('src.lua-cor.wrp')
  local typ       = require('src.lua-cor.typ')

  local Controller = require('src.model.space.controller')
  local playerid = require('src.model.playerid')
  local ex    = typ.new_ex(random)

  wrp.fn(log.trace, random, 'new',        random, Controller)
  wrp.fn(log.info, random, 'set_move',        ex, playerid)
  wrp.fn(log.trace, random, 'move_async', ex)
end

return random