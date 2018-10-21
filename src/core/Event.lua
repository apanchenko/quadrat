local ass = require 'src.core.ass'
local log = require 'src.core.log'

local Event = {}
Event.typename = 'Event'
Event.__index = Event

-- 
function Event.new(name)
  ass.string(name)
  local self = setmetatable({}, Event)
  self.list = {}
  self.name = name
  return self
end

--
function Event:__tostring()
  return 'event['.. self.name.. ' '.. #self.list.. ']'
end

-- add listener
function Event:add(listener)
  ass(listener)
  log:trace(self, ":add ", listener)
  table.insert(self.list, listener)
  log:trace(self, ":added ", listener)
end

-- remove listener
function Event:remove(listener)
  ass(listener)  
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
  ass.string(name)
  for k,v in ipairs(self.on_move) do
    v[name](v, ...)
  end
end

return Event