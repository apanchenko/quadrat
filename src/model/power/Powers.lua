local MoveDiagonal = require 'src.model.power.MoveDiagonal'
local Multiply     = require 'src.model.power.Multiply'
local Rehash       = require 'src.model.power.Rehash'
local Relocate     = require 'src.model.power.Relocate'
local Recruit      = require 'src.model.power.Recruit'
local Swap         = require 'src.model.power.Swap'
local Sphere       = require 'src.model.power.Sphere'
local Impeccable   = require 'src.model.power.Impeccable'
local Teach        = require 'src.model.power.Teach'
local Destroy      = require 'src.model.power.Destroy'


local Powers =
{
  MoveDiagonal, Multiply, Recruit, --Rehash, Relocate, , Swap, Sphere,
  Impeccable, Teach, Destroy
}

--
function Powers.Find(name)
  for k,v in ipairs(Powers) do
    if tostring(v) == name then
      return v
    end
  end
end


return Powers