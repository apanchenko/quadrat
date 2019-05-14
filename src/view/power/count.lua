local obj         = require 'src.lua-cor.obj'
local typ         = require 'src.lua-cor.typ'
local ass         = require 'src.lua-cor.ass'
local log         = require 'src.lua-cor.log'
local wrp         = require 'src.lua-cor.wrp'
local lay         = require 'src.lua-cor.lay'
local cfg         = require 'src.cfg'

-- power draws a counter ------------------------------------------------------
local count = obj:extend('view.power.count')

-- constructor
function count:new(stone, name, count)
  self = obj.new(self)
  self.count = count
  self.text = lay.text(stone, {x=0, y=0, text=tostring(count), fontSize=22})
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
function count:wrap()
  wrp.wrap_sub_trc(count, 'new', {'stone'}, {'name', typ.str}, {'count', typ.num})
  wrp.wrap_sub_trc(count, 'set_count', {'count', typ.num})
end

return count