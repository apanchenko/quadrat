local _ = require 'src.core.underscore'

local log = {}
log.__index = log

function log.new()
  local self = setmetatable({}, log)
  self.depth = 0
  return self
end

function log.name()
  return "log"
end

function log:enter()
  self.depth = self.depth + 1
  return self
end

function log:exit()
  self.depth = self.depth - 1
  return self
end

function log:trace(...)
  local str = string.rep("  ", self.depth)
  str = _.reduce(arg, str, function(mem, a) return mem .. tostring(a) end)
  print(str)
  return self
end


return log