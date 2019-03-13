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
  arr.each({...}, function(name)
    local fullname = self.path.. '.'.. name
    local module = require(fullname)
    ass(module, 'failed found module '.. fullname)
    ass.nul(self.modules[name], 'module '.. name.. ' already loaded')
    self.modules[name] =  module
  end)
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
  local depth = log:trace(self.path..':[pkg]wrap'):enter()
  -- for all modules
  for id, module in pairs(self.modules) do
    -- call wrap from this module strictly
    local mod_wrap = rawget(module, 'wrap')
    if mod_wrap then
      local depth = log:trace(id..'.wrap'):enter()
      mod_wrap()
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
  local depth = log:trace(self.path..':[pkg]test'):enter()
  for id, module in pairs(self.modules) do
    -- call test from this module strictly
    local mod_test = rawget(module, 'test')
    if mod_test then
      local depth = log:trace(id..'.test'):enter()
      mod_test()
      log:exit(depth)
    end
  end
  log:exit(depth)
end

-- core package
pkg.cor = pkg:new('src.core')
pkg.cor:load('arr', 'ass', 'chk', 'cnt', 'env', 'evt', 'lay', 'log', 'map', 'obj', 'typ', 'vec', 'wrp')

-- module
return pkg