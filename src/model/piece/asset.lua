local obj = require('src.lua-cor.obj')
local arr = require('src.lua-cor.arr')

-- piece interface for one of players
local asset = obj:extend('asset')

local _ =
{
  piece = {}, -- what
  ctrl = {} -- who owns
}

--
function asset:new(piece_model, controller)
  self = obj.new(self)
  self[_.piece] = piece_model
  self[_.ctrl] = controller
  return self
end

--
function asset:get_space()
  return self[_.ctrl]
end
function asset:set_controller(controller)
  self[_.ctrl] = controller
end

--
function asset:get_pid()
  return self[_.piece]:get_pid()
end

--
function asset:is_friend()
  return self[_.piece]:get_pid() == self[_.ctrl]:get_pid()
end

-- is piece jaded
function asset:is_jaded()
  return not self[_.piece].jades_cnt:is_empty()
end

--
function asset:is_jump_protected()
  return self[_.piece]:is_jump_protected()
end

-- get all jade ids
function asset:get_jades()
  if self:is_friend() then
    return self[_.piece].jades_cnt:keys()
  end
  return arr()
end

-- use jade by id
function asset:use_jade(id)
  if self:is_friend() then
    self[_.piece]:use_jade(id) 
  end
end

--
function asset:is_invisible()
  if self:is_friend() then
    return self[_.piece]:count_power(invis:get_typename())
  end
  return false
end


-- MOVE ----------------------------------------------------------------------
--
function asset:can_move(to)
  if self:is_friend() then
    return self[_.ctrl]:can_move(self[_.piece]:get_pos(), to)
  end
  return false;
end

--
function asset:move(to)
  if self:is_friend() then
    self[_.ctrl]:move(self[_.piece]:get_pos(), to)
  end
end

-- return array of available move targets
function asset:get_move_to_arr()
  local to_arr = arr()
  if self:is_friend() then
    local space = self[_.ctrl]
    local from = self[_.piece]:get_pos()
    space:get_size():iterate_grid(function(to)
      if space:can_move(from, to) then
        to_arr:push(to)
      end
    end)
  end
  return to_arr
end

-- wrap functions
function asset:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local vec = require('src.lua-cor.vec')
  local log = require('src.lua-cor.log').get('mode')
  local piece_model = require('src.model.piece.piece')
  local Controller = require('src.model.space.Controller')

  local ex = typ.new_ex(asset)

  wrp.fn(log.info, asset, 'new',       asset, piece_model, Controller)
  wrp.fn(log.info, asset, 'get_pid',   ex)
  wrp.fn(log.info, asset, 'is_friend', ex)
  wrp.fn(log.info, asset, 'is_jaded',  ex)
  wrp.fn(log.info, asset, 'is_jump_protected', ex)

  wrp.fn(log.info,  asset, 'get_jades',   ex)
  wrp.fn(log.trace, asset, 'use_jade',   ex, typ.str)
  wrp.fn(log.info,  asset, 'is_invisible', ex)

  -- move
  wrp.fn(log.info,  asset, 'can_move',        ex, vec)
  wrp.fn(log.info,  asset, 'move',            ex, vec)
  wrp.fn(log.info,  asset, 'get_move_to_arr', ex)

end

return asset