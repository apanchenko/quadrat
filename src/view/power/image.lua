local obj         = require 'src.lua-cor.obj'
local typ       = require 'src.lua-cor.typ'
local log         = require('src.lua-cor.log').get('view')
local wrp         = require 'src.lua-cor.wrp'

local image = obj:extend('view.power.image')

-- constructor
-- create image with initial one count
function image:new(stone, id)
  self = obj.new(self, {
    stone = stone,
    name = id
  })
  self.stone:view().show(id)
  return self
end
--
function image:destroy()
end

--
function image:set_count(count)
  if count > 0 then
    return self
  end
  self.stone:view().hide(self.name)
end


--MODULE-----------------------------------------------------------------------
function image:wrap()
  local ex    = {'eximage', typ.new_ex(image)}
  wrp.fn(log.trace, image, 'new',        ex, {'stone'}, {'name', typ.str}, {'count', typ.num})
  wrp.fn(log.trace, image, 'set_count',  ex, {'count', typ.num})
end

return image