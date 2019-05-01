local arr         = require 'src.core.arr'
local map         = require 'src.core.map'
local obj         = require 'src.core.obj'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'

-- Core dependency graph:
-- typ bld
-- chk
-- ass
-- log
-- wrp lay
-- arr
-- map
-- obj
-- env evt pkg vec

--
local pkg = obj:extend('pkg')

-- constructor
function pkg:new(path)
  return obj.new(self,
  {
    path = path,
    modules = {}
  })
end

-- load module to package
function pkg:load(...)
  local args = {...}
  local depth = log:info(self.path..':load('..arr.tostring(args)..')'):enter()
  arr.each(args, function(name)
    local fullname = self.path.. '.'.. name
    local module = require(fullname)
    ass(module, 'failed found module '.. fullname)
    ass.nul(self.modules[name], 'module '.. name.. ' already loaded')
    self.modules[name] = module
  end)
  log:exit(depth)
  return self
end

--
function pkg:get(name)
  return self.modules[name]
end

-- deprecated
pkg.find = pkg.get

-- wrap modules
function pkg:wrap()
  -- cannot wrap the wrapper so do logging manually
  local depth = log:trace(self.path..':wrap'):enter()
  -- for all modules
  for id, module in pairs(self.modules) do
    if module.wrap then
      local depth = log:trace(id..':wrap'):enter()
      module:wrap()
      log:exit(depth)
    end
  end
  log:exit(depth)
end

-- get random module
function pkg:random(pred)
  if pred then
    return arr.random(map.select(self.modules, pred))
  end
  return map.random(self.modules)
end

-- test modules
function pkg:test()
  -- cannot wrap the wrapper so do logging manually
  local depth = log:trace(self.path..':test'):enter()
  for id, module in pairs(self.modules) do
    local mod_test = module.test
    if mod_test then
      local depth = log:trace(id..':test'):enter()
      mod_test(module)
      log:exit(depth)
    end
  end
  log:exit(depth)
end

-- module
return pkg