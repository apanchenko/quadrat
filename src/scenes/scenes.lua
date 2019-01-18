local scenes =
{
  solo    = require 'src.scenes.solo',
  lobby   = require 'src.scenes.lobby',
  battle  = require 'src.scenes.battle',
  exit    = function() native.requestExit() end
}

function scenes.test()
  scenes.battle.test()
end

return scenes