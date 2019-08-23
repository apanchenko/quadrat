local obj = require('src.lua-cor.obj')

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
  local typ = require('src.lua-cor.typ')
  local log = require('src.lua-cor.log').get('view')
  local wrp = require('src.lua-cor.wrp')
  local stone = require('src.view.stone.stone')

  local ex    = typ.new_ex(image)
  wrp.fn(log.trace, image, 'new',        image, stone, typ.str, typ.num)
  wrp.fn(log.trace, image, 'set_count',  ex, typ.num)
end

return image