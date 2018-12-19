local obj         = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local cfg         = require 'src.Config'

local image = obj:extend('view.power.image')

-- constructor
-- create image with initial one count
function image:new(stone, name, count)
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
ass.wrap(image, ':new', 'Stone', typ.str, 1)
ass.wrap(image, ':set_count', typ.num)

log:wrap(image, 'new', 'set_count')

return image