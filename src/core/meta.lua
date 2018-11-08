local Ass = require 'src.core.Ass'
local log = require 'src.core.log'

local meta = {}
local meta.typename = 'meta'

function meta.create_class(typename)
  Ass.String(typename)
  local class = {}
  class.typename = 'ChangeLog'
  class.__index = ChangeLog
  class.new = function()
    local self = setmetatable({}, class)
    return self
  end