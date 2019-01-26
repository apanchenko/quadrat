local obj         = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local wrp         = require 'src.core.wrp'
local cfg         = require 'src.cfg'

local image = obj:extend('view.power.image')

-- constructor
-- create image with initial one count
function image:new(stone, name)
  self = obj.new(self)
  self.image = lay.image(stone, cfg.cell, 'src/view/power/'..name..'.png')
  return self
end

--
function image:set_count(count)
  if count > 0 then
    return self
  end
  self.image:removeSelf()
end


--MODULE-----------------------------------------------------------------------
wrp.fn(image, 'new', {{'Stone'}, {'name', typ.str}, {'count', typ.num}})
wrp.fn(image, 'set_count', {{'count', typ.num}})

return image