local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local obj       = require 'src.core.obj'
local wrp       = require 'src.core.wrp'

--
local user = obj:extend('user')

-- create
function user:new(env, pid)
  return obj.new(self,
  {
    env = env,
    pid = pid
  })
end
-- listen board
function user:on_board(board)
  board.on_change:add(self)
end
--
function user:__tostring()
  return 'player.user['..tostring(self.pid)..']'
end
--
function user:on_spawn_stone(stone)
  if stone.pid == self.pid then
    log:trace('register ', stone, ' to listen itself')
    stone.view:addEventListener("touch", stone)
  end
end

-- MODULE ---------------------------------------------------------------------
log:wrap_fn(user, 'new', {{'env'}, {'pid', 'playerid'}})
log:wrap_fn(user, 'on_spawn_stone', {{'Stone'}})

return user