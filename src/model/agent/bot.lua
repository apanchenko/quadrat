local log = require('src.lua-cor.log').get('mode')
local obj = require('src.lua-cor.obj')
local vec = require('src.lua-cor.vec')
local com = require('src.lua-cor.com')

-- smarter bot
local bot = obj:extend('bot')

-- private
local _space = {}

-- create
function bot:new(space)
  self = obj.new(self, com())
  self[_space] = space
  space:add_listener(self)
  return self
end

--
function bot:move(pid)
  if self[_space]:is_my_move() then
    timer.performWithDelay(1000, function() self:move_async() end)
  end
end

--
function bot:move_async()
  local attempts = 1000
  local space = self[_space]

  -- do something until can move
  while space:is_my_move() do
    -- select random piece of my color
    local from = vec:random(vec.zero, space:get_size() - vec.one)
    local piece = space:get_piece(from)

    if piece and piece:is_friend() then
      -- execute random ability
      --local jade = piece.jades:random()
      --if jade then
      --  piece:use_jade(jade.id)
      --end
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

-- Position evaluation
-- S = friends_count + abilities_count - enemies_count - jaded_enemy_count
function bot:evaluate()
  local space = self[_space]
  local size = space:get_size()
  local evaluation = 0
  size:iterate_grid(function(pos)
    local piece = space:get_piece(pos)
    if piece:is_friend() then
      evaluation = evaluation + 1
    else
      evaluation = evaluation - 1
    end
  end)
end

--
function bot:wrap()
  local wrp       = require 'src.lua-cor.wrp'
  local typ       = require 'src.lua-cor.typ'

  local space_agent = require('src.model.space.agent')
  local is = {'bot', typ.new_is(bot)}
  local sp = {'space_agent', typ.new_is(space_agent)}

  wrp.fn(log.trace, bot, 'new', is, sp)
end

return bot