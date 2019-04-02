local obj         = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local wrp         = require 'src.core.wrp'
local lay         = require 'src.core.lay'
local cfg         = require 'src.cfg'

local image = obj:extend('view.power.image')

-- constructor
-- create image with initial one count
function image:new(stone, name)
  self = obj.new(self)
  cfg.view.cell.path = 'src/view/power/'..name..'.png'
  cfg.view.cell.order = 10
  self.image = lay.image(stone, cfg.view.cell)
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
function image.wrap()
  wrp.fn(image, 'new',        {{'stone'}, {'name', typ.str}, {'count', typ.num}})
  wrp.fn(image, 'set_count',  {{'count', typ.num}})
end

return image