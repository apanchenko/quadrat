local obj         = require 'src.lua-cor.obj'
local typ       = require 'src.lua-cor.typ'
local ass         = require 'src.lua-cor.ass'
local log         = require 'src.lua-cor.log'
local wrp         = require 'src.lua-cor.wrp'
local lay         = require 'src.lua-cor.lay'
local cfg         = require 'src.cfg'

local image = obj:extend('view.power.image')

-- constructor
-- create image with initial one count
function image:new(env, stone, name)
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
  wrp.wrap_sub_trc(image, 'new',        {'env'}, {'stone'}, {'name', typ.str}, {'count', typ.num})
  wrp.wrap_sub_trc(image, 'set_count',  {'count', typ.num})
end

return image