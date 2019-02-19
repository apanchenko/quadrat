local obj         = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local wrp         = require 'src.core.wrp'
local cfg         = require 'src.model.cfg'

-- power draws a counter ------------------------------------------------------
local count = obj:extend('view.power.count')

-- constructor
function count:new(stone, name, count)
  self = obj.new(self)
  self.count = count
  self.text = lay.text(stone, {text=tostring(count), fontSize=22})
  return self
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
function count.wrap()
  wrp.fn(count, 'new', {{'stone'}, {'name', typ.str}, {'count', typ.num}})
  wrp.fn(count, 'set_count', typ.num)
end

return count