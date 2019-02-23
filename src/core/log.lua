local ass = require 'src.core.ass'
local bld = require 'src.core.bld'

-- Create log.
local log = { depth = 0 }

--
local function out(...)
  local str = string.rep('. ', log.depth)
  for i = 1, #arg do
    str = str.. tostring(arg[i]).. ' '
  end
  print(str)
end

-- configure log
function log:on_cfg(cfg)
  -- dumb is always silent
  self.dumb = function(me) return me end

  -- info for debug configuration only
  if cfg.build.id <= bld.debug.id then
    self.info  = function(me, ...) out(...) return me end
  else
    self.info  = self.dumb
  end

  -- trace for debug and develop configurations
  if cfg.build.id <= bld.develop.id then
    self.trace = function(me, ...) out(...) return me end
  else
    self.trace = self.dumb
  end

  -- error and warning for all configurations
  self.error   = function(me, ...) out('Error', ...) return me end
  self.warning = function(me, ...) out('Warning', ...) return me end

  self:trace('log:on_cfg '..cfg.build.name)
end

-- increase stack depth
function log:enter()
  self.depth = self.depth + 1
  return self.depth
end

-- decrease stack depth
function log:exit(depth)
  ass.eq(self.depth, depth)
  self.depth = depth - 1
end

--
function log.test()
end

return log