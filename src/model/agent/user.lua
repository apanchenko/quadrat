local log       = require('src.lua-cor.log').get('mode')
local obj       = require('src.lua-cor.obj')
local com       = require 'src.lua-cor.com'

-- controller for user
local user = obj:extend('user')

--private
local space = {}

-- create
function user:new(Controller)
  local this = obj.new(self, com())
  this[space] = Controller
  return this
end

--
function user:__tostring()
  return 'player.user['..tostring(self[space]:get_pid())..']'
end

-- event from board
function user:spawn_stone(stone)
  if stone:get_pid() == self[space]:get_pid() then
    log.info('register ', stone, ' to listen itself')
    stone:activate_touch()
  end
end

-- event from board
function user:stone_color_changed(stone)
  if stone:get_pid() == self[space]:get_pid() then
    log.trace('register ', stone, ' to listen itself')
    stone:activate_touch()
  else
    log.trace('unregister ', stone, ' listen touch')
    stone:deactivate_touch()
  end
end

-- MODULE ---------------------------------------------------------------------
--
function user:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local Controller = require('src.model.space.controller')
  local stone = require('src.view.stone.stone')

  wrp.fn(log.trace, user, 'new',            user, Controller)
  wrp.fn(log.trace, user, 'spawn_stone',        typ.new_ex(user), stone)
  wrp.fn(log.trace, user, 'stone_color_changed', typ.new_ex(user), stone)
end

return user