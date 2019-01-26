local ass = require 'src.core.ass'
local bld = require 'src.core.bld'

-- Create log.
local log = { depth = 0 }

--
local function out(severity, ...)
  local str = severity.. string.rep('  ', log.depth)
  for i = 1, #arg do
    str = str.. tostring(arg[i]).. ' '
  end
  print(str)
end

-- configure log
function log:on_cfg(cfg)
  if cfg.build == bld.debug then
    self.info  = function(me, ...) out('inf ', ...) return me end
    self.trace = function(me, ...) out('trc ', ...) return me end
  else
    self.info  = function(me)                       return me end
    self.trace = function(me)                       return me end
  end
  self.error   = function(me, ...) out('err ', ...) return me end
  self.warning = function(me, ...) out('wrn ', ...) return me end
  self:trace('log:on_cfg '..cfg.build.name)
end

-- increase stack depth
function log:enter()
  self.depth = self.depth + 1
  return self.depth
end

-- decrease stack depth
function log:exit(depth)
  assert(self.depth == depth)
  self.depth = depth - 1
end

--
function log.test()
  ass.eq(log:enter(), 1)
  log:exit(1)
end

return log