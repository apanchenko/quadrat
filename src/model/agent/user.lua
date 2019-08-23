local log       = require('src.lua-cor.log').get('mode')
local obj       = require 'src.lua-cor.obj'
local com       = require 'src.lua-cor.com'

-- controller for user
local user = obj:extend('user')

--private
local space = {}

-- create
function user:new(space_agent)
  local this = obj.new(self, com())
  this[space] = space_agent
  return this
end

--
function user:__tostring()
  return 'player.user['..tostring(self[space]:get_my_pid())..']'
end

-- event from board
function user:on_spawn_stone(stone)
  if stone.pid == self[space]:get_my_pid() then
    log.info('register ', stone, ' to listen itself')
    stone:activate_touch()
  end
end

-- event from board
function user:on_stone_color_changed(stone)
  if stone.pid == self[space]:get_my_pid() then
    log.info('register ', stone, ' to listen itself')
    stone:activate_touch()
  else
    log.info('unregister ', stone, ' listen touch')
    stone:deactivate_touch()
  end
end

-- MODULE ---------------------------------------------------------------------
--
function user:wrap()
  local wrp = require 'src.lua-cor.wrp'
  local typ = require 'src.lua-cor.typ'
  local space_agent = require('src.model.space.agent')
  local stone = require('src.view.stone.stone')

  wrp.fn(log.trace, user, 'new',            user, space_agent)
  wrp.fn(log.trace, user, 'on_spawn_stone', typ.new_ex(user), stone)
end

return user