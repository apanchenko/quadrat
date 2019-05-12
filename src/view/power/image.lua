local obj         = require 'src.luacor.obj'
local typ       = require 'src.luacor.typ'
local ass         = require 'src.luacor.ass'
local log         = require 'src.luacor.log'
local wrp         = require 'src.luacor.wrp'
local lay         = require 'src.luacor.lay'
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
function image:wrap()
  wrp.wrap_sub_trc(image, 'new',        {'stone'}, {'name', typ.str}, {'count', typ.num})
  wrp.wrap_sub_trc(image, 'set_count',  {'count', typ.num})
end

return image