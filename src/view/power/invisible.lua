local obj         = require 'src.lua-cor.obj'
local typ         = require 'src.lua-cor.typ'
local ass         = require 'src.lua-cor.ass'
local wrp         = require 'src.lua-cor.wrp'
local com         = require 'src.lua-cor.com'

local invisible = obj:extend('view.power.invisible')

-- create image with initial one count
function invisible:new(env, stone, id, count)
  ass.eq(count, 1)
  self = obj.new(self, com())
  self.env = env
  self.stone = stone

  self:move(self.env.space:who_move())
  self.env.space.opp_evt.add(self)
  return self
end
--
function invisible:destroy()
  self.env.space.opp_evt:remove(self)
  self.stone = nil
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
  local is   = {'invisible', typ.new_is(invisible)}
  local ex    = {'exinvisible', typ.new_ex(invisible)}
  local count = {'count', typ.num}

  wrp.fn(log.trace, invisible, 'new',        is, {'env'}, {'stone'}, {'id', typ.str}, count)
  wrp.fn(log.trace, invisible, 'set_count',  ex, count)
  wrp.fn(log.trace, invisible, 'move',       ex, {'playerid'})
end

return invisible