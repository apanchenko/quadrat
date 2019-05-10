local obj         = require 'src.core.obj'
local typ         = require 'src.core.typ'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local wrp         = require 'src.core.wrp'
local lay         = require 'src.core.lay'
local cfg         = require 'src.cfg'

local invisible = obj:extend('view.power.invisible')

-- constructor
-- create image with initial one count
function invisible:new(stone, id, count)
  ass.eq(count, 1)
  stone.view.alpha = 0.5
  return obj.new(self, {view = stone.view})
end

--
function invisible:set_count(count)
  if count > 0 then
    return self
  end
  self.view.alpha = 1
  self.image:removeSelf()
end


--MODULE-----------------------------------------------------------------------
function invisible:wrap()
  local count = {'count', typ.num}
  wrp.wrap_tbl_trc(image, 'new',        {'stone'}, {'id', typ.str}, count)
  wrp.wrap_sub_trc(image, 'set_count',  count)
end

return invisible