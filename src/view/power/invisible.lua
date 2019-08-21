local ass         = require 'src.lua-cor.ass'
local obj         = require 'src.lua-cor.obj'
local com         = require 'src.lua-cor.com'

local invisible = obj:extend('view.power.invisible')

-- private
local _stone = {}

-- create image with initial one count
function invisible:new(stone, id, count)
  ass.eq(count, 1)
  self = obj.new(self, com())
  self[_stone] = stone

  self:move(stone:get_piece():who_move())
  self[_stone]:get_piece():listen_set_move(self, true)
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
function invisible:move(pid)
  local alpha = 0
  if self.stone:get_pid() == pid then
    alpha = 0.5
  end
  self.stone:view().alpha = alpha
end

--MODULE-----------------------------------------------------------------------
function invisible:wrap()
  local typ         = require 'src.lua-cor.typ'
  local wrp         = require 'src.lua-cor.wrp'
  local log         = require('src.lua-cor.log').get('view')

  local is   = {'invisible', typ.new_is(invisible)}
  local ex    = {'exinvisible', typ.new_ex(invisible)}
  local count = {'count', typ.num}

  wrp.fn(log.trace, invisible, 'new',        is, {'stone'}, {'id', typ.str}, count)
  wrp.fn(log.trace, invisible, 'set_count',  ex, count)
  wrp.fn(log.trace, invisible, 'move',       ex, {'playerid'})
end

return invisible