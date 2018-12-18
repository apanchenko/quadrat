local ass = require 'src.core.ass'
local log = require 'src.core.log'
local typ = require 'src.core.typ'
local obj = require 'src.core.obj'

local evt = obj:extend('evt')

-- 
local obj_create = obj.create
function evt:create()
  local this = obj_create(self)
  this.list = {}
  return this
end

-- add listener
function evt:add(listener)
  table.insert(self.list, listener)
end

-- remove listener
function evt:remove(listener)
  for k,v in ipairs(self.list) do
    if v == listener then
      table.remove(self.list, k)
    end
  end
end

--
function evt:__call(...)
  local depth = log:trace(self, ":call", ...):enter()
  for k,v in ipairs(self.list) do
    v[self.name](v, ...)
  end
  log:exit(depth)
end

--
function evt:call(name, ...)
  name = name or self.name
  ass.str(name)
  for k,v in ipairs(self.list) do
    if v[name] then
      v[name](v, ...)
    end
  end
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(evt, ':add', typ.tab)
ass.wrap(evt, ':remove', typ.tab)

log:wrap(evt, 'call')

return evt