local Row = require 'src.model.zones.Row'
local Col = require 'src.model.zones.Col'
local Rad = require 'src.model.zones.Radial'

local Zones = {Row, Col, Rad}

-- selftest
function Zones.test()
  for i = 1, #Zones do
    Zones[i].Test()
  end
end

return Zones