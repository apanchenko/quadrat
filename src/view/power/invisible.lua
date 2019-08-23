local ass         = require 'src.lua-cor.ass'
local obj         = require('src.lua-cor.obj')
local com         = require 'src.lua-cor.com'

local invisible = obj:extend('view.power.invisible')

-- private
local _stone = {}

-- create image with initial one count
function invisible:new(stone, id, count)
  ass.eq(count, 1)
  self = obj.new(self, com())
  self[_stone] = stone

  local piece = stone:get_piece()
  self:set_move(piece:get_space():get_move_pid())
  piece:listen_set_move(self, true)
  return self
end
--
function invisible:destroy()
  self[_stone]:get_piece():listen_set_move(self, false)
  self[_stone] = nil
end

--
function invisible:set_count(count)
  if count > 0 then
    return self
  end
  self.stone:view().alpha = 1
end

-- space event
function invisible:set_move(pid)
  local alpha = 0
  if self[_stone]:get_pid() == pid then
    alpha = 0.5
  end
  self[_stone]:view().alpha = alpha
end

--MODULE-----------------------------------------------------------------------
function invisible:wrap()
  local typ   = require('src.lua-cor.typ')
  local wrp   = require('src.lua-cor.wrp')
  local log   = require('src.lua-cor.log').get('view')
  local stone = require('src.view.stone.stone')
  local playerid = require('src.model.playerid')

  local ex    = typ.new_ex(invisible)

  wrp.fn(log.trace, invisible, 'new',        invisible, stone, typ.str, typ.num)
  wrp.fn(log.trace, invisible, 'set_count',  ex, typ.num)
  wrp.fn(log.trace, invisible, 'set_move',   ex, playerid)
end

return invisible