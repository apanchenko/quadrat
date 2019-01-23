local arr         = require 'src.core.arr'

local package =
{
  stone           = require 'src.view.Stone',
  stone_abilities = require 'sec.view.StoneAbilities'
}

--
local function wrap()
  arr.invoke(package, 'wrap')
end

--
package.wrap = wrap
return package