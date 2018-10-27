-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local composer = require("composer")
print(_VERSION)
require('src.core.Vec').test()

composer.gotoScene("src.Menu")


--[[
local T = {}
T.__index = T

function T.new()
  return setmetatable({v='T'}, T)
end

function T:a()
  print (self.v .. 'a')
end

function T.b()
  print 'b'
end

local t = T.new()
t["a"](t)
t["b"]()
]]--