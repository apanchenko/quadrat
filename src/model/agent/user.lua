local ass       = require 'src.lua-cor.ass'
local log       = require 'src.lua-cor.log'
local obj       = require 'src.lua-cor.obj'
local wrp       = require 'src.lua-cor.wrp'
local typ       = require 'src.lua-cor.typ'

-- controller for user
local user = obj:extend('user')

-- create
function user:new(env, pid)
  ass.eq(tostring(env), 'env')
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
    log:info('register ', stone, ' to listen itself')
    stone.view:addEventListener("touch", stone)
  end
end

--
function user:on_stone_color_changed(stone)
  if stone.pid == self.pid then
    log:info('register ', stone, ' to listen itself')
    stone.view:addEventListener('touch', stone)
  else
    log:info('unregister ', stone, ' listen touch')
    stone.view:removeEventListener('touch', stone)
  end
end

-- MODULE ---------------------------------------------------------------------
--
function user:wrap()
  wrp.wrap_tbl_trc(user, 'new',            {'env'}, {'pid', 'playerid'})
  wrp.wrap_sub_trc(user, 'on_spawn_stone', {'stone'})
end

return user