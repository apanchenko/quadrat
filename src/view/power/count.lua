local obj         = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local cfg         = require 'src.Config'

-- power draws a counter ------------------------------------------------------
local count = obj:extend('view.power.count')

-- constructor
local obj_create = obj.create
function count:create(stone, name, count)
  local this = obj_create(self)
  this.count = count
  this.text = lay.text(stone, {text=tostring(count), fontSize=22})
  return this
end

--
function count:set_count(count)
  if count > 0 then
    self.count = count
    self.text.text = tostring(count)
    return self
  end

  self.text:removeSelf()
end


--MODULE-----------------------------------------------------------------------
ass.wrap(count, ':create', 'Stone', typ.str, typ.num)
ass.wrap(count, ':set_count', typ.num)

log:wrap(count, 'create', 'set_count')

return count