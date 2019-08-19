local log = require('src.lua-cor.log').get('mode')
local obj = require('src.lua-cor.obj')
local arr = require('src.lua-cor.arr')
local com = require('src.lua-cor.com')
local move = require('src.model.move')

-- smarter bot
local bot = obj:extend('bot')

-- private
local _space = {}

-- create
function bot:new(space_agent)
  self = obj.new(self, com())
  self[_space] = space_agent
  self[_space]:add_listener(self)
  return self
end

--
function bot:move(pid)
  if self[_space]:is_my_move() then
    timer.performWithDelay(100, function() self:move_async() end)
  end
end

--
function bot:move_async()
  local space = self[_space]
  local pid = space:get_my_pid()
  local best_move_arr = arr()
  local best_value = -1

  space:get_size():iterate_grid(function(from)

    local piece = space:get_piece(from)
    if piece and piece:is_friend() then

      piece:get_move_to_arr():each(function(to)
        local my_value = 0

        -- check safe moving to
        local friend_support = space:get_support_count(to, pid) - 1
        local enemy_support = space:get_support_count(to, pid:other())
        if friend_support >= enemy_support then
          -- eat enemy
          local enemy = space:get_piece(to)
          if enemy then
            if enemy:is_jaded() then
              my_value = my_value + 6
            else
              my_value = my_value + 5
            end
          end

          -- eat jade
          if space:has_jade(to) then
            my_value = my_value + 4
          end

          -- better influence (max 3)
          local from_support = space:get_support_count(from, pid)
          if from_support > friend_support then
            my_value = my_value + (from_support - friend_support)
          end
        end

        -- save move
        if my_value > best_value then
          log.trace('Better move', from, '->', to, '=', my_value, 'Support', friend_support, 'vs', enemy_support)
          best_value = my_value
          best_move_arr = arr(move(from, to))
        elseif my_value == best_value then
          log.trace('Equal move ', from, '->', to, '=', my_value, 'Support', friend_support, 'vs', enemy_support)
          best_move_arr:push(move(from, to))
        end

      end) -- each to

    end -- if friend

  end) -- each spot

  -- do selected move
  local best_move = best_move_arr:random()
  if best_move then
    space:move(best_move:get_from(), best_move:get_to())
  else
    log.trace('cannot find move')
  end

end

--
function bot:wrap()
  local wrp       = require 'src.lua-cor.wrp'
  local typ       = require 'src.lua-cor.typ'

  local space_agent = require('src.model.space.agent')
  local is = {'bot', typ.new_is(bot)}
  local ex = {'bot', typ.new_ex(bot)}
  local sp = {'space_agent', typ.new_is(space_agent)}

  wrp.fn(log.trace, bot, 'new', is, sp)
  wrp.fn(log.trace, bot, 'move_async', ex)
end

return bot