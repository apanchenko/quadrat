local obj         = require 'src.lua-cor.obj'
local typ         = require 'src.lua-cor.typ'
local ass         = require 'src.lua-cor.ass'
local wrp         = require 'src.lua-cor.wrp'

local invisible = obj:extend('view.power.invisible')

-- create image with initial one count
function invisible:new(env, stone, id, count)
  ass.eq(count, 1)
  self = obj.new(self, {
    env = env,
    stone = stone,
  })
  self:move(self.env.space:who_move())
  self.env.space.opp_evt:add(self)
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
  self.stone._view.alpha = 1
end

-- space event
function invisible:move(pid)
  local alpha = 0
  if self.stone:get_pid() == pid then
    alpha = 0.5
  end
  self.stone._view.alpha = alpha
end

--MODULE-----------------------------------------------------------------------
function invisible:wrap()
  local count = {'count', typ.num}

  wrp.wrap_tbl(log.trace, invisible, 'new',        {'env'}, {'stone'}, {'id', typ.str}, count)
  wrp.wrap_sub(log.trace, invisible, 'set_count',  count)
  wrp.wrap_sub(log.trace, invisible, 'move',       {'playerid'})
end

return invisible