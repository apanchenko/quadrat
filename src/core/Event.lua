local Class = require 'src.core.Class'
local ass = require 'src.core.ass'
local log = require 'src.core.log'
local types = require 'src.core.types'

local Event = Class.Create('Event')

-- 
function Event.New(name)
  local self = setmetatable({}, Event)
  self.list = {}
  self.name = name
  return self
end

--
function Event:__tostring()
  return 'event'
end

-- add listener
function Event:add(listener)
  log:trace(self, ":add ", listener)
  table.insert(self.list, listener)
end

-- remove listener
function Event:remove(listener)
  for k,v in ipairs(self.list) do
    if v == listener then
      table.remove(self.list, k)
    end
  end
end

--
function Event:__call(...)
  local depth = log:trace(self, ":call", ...):enter()
  for k,v in ipairs(self.list) do
    v[self.name](v, ...)
  end
  log:exit(depth)
end

--
function Event:call(name, ...)
  name = name or self.name
  ass.str(name)
  for k,v in ipairs(self.list) do
    if v[name] then
      v[name](v, ...)
    end
  end
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(Event, ':add', types.tab)
ass.wrap(Event, ':remove', types.tab)

log:wrap(Event, 'call')

return Event