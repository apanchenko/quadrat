local MoveDiagonal = require 'src.model.powers.MoveDiagonal'
local Multiply     = require 'src.model.powers.Multiply'
local Rehash       = require 'src.model.powers.Rehash'
local Relocate     = require 'src.model.powers.Relocate'
local Recruit      = require 'src.model.powers.Recruit'
local Swap         = require 'src.model.powers.Swap'
local Sphere       = require 'src.model.powers.Sphere'
local Impeccable   = require 'src.model.powers.Impeccable'
local Teach        = require 'src.model.powers.Teach'
local Destroy      = require 'src.model.powers.Destroy'


local Powers =
{
  --MoveDiagonal, Multiply, Rehash, Relocate, Recruit, Swap, Sphere,
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