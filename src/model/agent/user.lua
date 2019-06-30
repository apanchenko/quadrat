local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('mode')
local obj       = require 'src.lua-cor.obj'
local wrp       = require 'src.lua-cor.wrp'
local typ       = require 'src.lua-cor.typ'
local com         = require 'src.lua-cor.com'

-- controller for user
local user = obj:extend('user')

-- create
function user:new(env, pid)
  ass.eq(tostring(env), 'env')
  local this = obj.new(self, com())
  this.env = env
  this.pid = pid
  return this
end

-- listen board
function user:on_board(board)
  board.on_change:listen(self)
end

--
function user:__tostring()
  return 'player.user['..tostring(self.pid)..']'
end

--
function user:on_spawn_stone(stone)
  if stone.pid == self.pid then
    log.info('register ', stone, ' to listen itself')
    stone:activate_touch()
  end
end

--
function user:on_stone_color_changed(stone)
  if stone.pid == self.pid then
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
  local is   = {'user', typ.new_is(user)}
  local ex    = {'exuser', typ.new_ex(user)}

  wrp.fn(log.trace, user, 'new',            is, {'env'}, {'pid', 'playerid'})
  wrp.fn(log.trace, user, 'on_spawn_stone', ex, {'stone'})
end

return user