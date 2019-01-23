local arr         = require 'src.core.arr'
local obj         = require 'src.core.obj'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'

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
end

-- wrap modules
function pkg:wrap()
  for name, mod in pairs(self.modules) do
    if mod.wrap then
      log:trace(name..'.wrap')
      mod.wrap()
    end
  end
end

-- test modules
function pkg:test()
  for name, mod in pairs(self.modules) do
    if mod.test then
      log:trace(name..'.test')
      mod.test()
    end
  end
end

-- core package
pkg.cor = pkg:new('src.core')
pkg.cor:load('arr', 'ass', 'chk', 'env', 'evt', 'lay', 'log', 'map', 'obj', 'typ', 'vec', 'wrp')

-- module
return pkg