local ass = require 'src.core.ass'
local log = require 'src.core.log'

local meta = {}
local meta.typename = 'meta'

function meta.create_class(typename)
  ass.string(typename)
  local class = {}
  class.typename = 'ChangeLog'
  class.__index = ChangeLog
  class.new = function()
    local self = setmetatable({}, class)
    return self
  end