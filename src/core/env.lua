local log   = require 'src.core.log'
local ass   = require 'src.core.ass'
local map   = require 'src.core.map'

local mt = {}
mt.__index = mt

-- notify created values about new value
function mt.__newindex(self, key, value)
  map.each(self, function(v)
    local cb = v['on_'..key]
    if cb then
      cb(v, value)
    end
  end)
  rawset(self, key, value)
end

-- self test
function mt.test()
  log:trace('env.test')
  -- create local test environment
  local env = setmetatable({}, mt)
  -- sideeffect of changing environment
  local side = 1 
  -- b listens c
  env.a = {on_b = function(self, b) side = b end}
  -- set c with sideeffect
  env.b = 9
  -- observe sideeffect
  ass.eq(side, 9)
end

-- create clean environment
return setmetatable({}, mt)