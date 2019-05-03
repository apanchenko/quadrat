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
    names = {}, -- array of module names, keeping order
    modules = {} -- map id->module
  })
end

-- load module to package
function pkg:load(...)
  self.names = {...}
  local depth = log:info(self.path..':load('..arr.tostring(self.names)..')'):enter()
  arr.each(self.names, function(name)
    log:info(name)
    local fullname = self.path.. '.'.. name
    local mod = require(fullname)
    ass(mod, 'failed found module '.. fullname)
    ass.nul(self.modules[name], 'module '.. name.. ' already loaded')
    self.modules[name] = mod
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
  arr.each(self.names, function(name)
    local mod = self.modules[name]
    if mod.wrap then
      local depth = log:trace(name..':wrap'):enter()
      mod:wrap()
      log:exit(depth)
    end
  end)
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
  arr.each(self.names, function(name)
    local mod = self.modules[name]
    if mod.test then
      local depth = log:trace(id..':test'):enter()
      mod:test()
      log:exit(depth)
    end
  end)
  log:exit(depth)
end

-- module
return pkg