local ass = require 'src.core.ass'
local bld = require 'src.core.bld'
local cfg = require 'src.cfg'

-- create log instance
local log = { depth = 0 }

--
local function out(severity, ...)
  local str = severity.. string.rep('  ', log.depth)
  for i = 1, #arg do
    str = str.. tostring(arg[i]).. ' '
  end
  print(str)
end

-- chained
function log:error(...)   out('err ', ...) return self end
function log:warning(...) out('wrn ', ...) return self end
function log:trace(...)   out('trc ', ...) return self end

if cfg.build == bld.debug then
  log.info = function(self, ...) out('inf ', ...) return self end
else
  log.info = function(self) return self end
end

log.severity =
{
  err = log.error,
  wrn = log.warning,
  trc = log.trace,
  inf = log.info
}

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