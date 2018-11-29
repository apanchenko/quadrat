local map     = require 'src.core.map'
local Type    = require 'src.core.Type'
local Ass     = require 'src.core.Ass'
local log     = require 'src.core.log'
local Vec     = require 'src.core.Vec'
local Color   = require 'src.model.Color'
local Ability = require 'src.model.Ability'

--
local RandomPlayer = Type.Create 'RandomPlayer'

-- create
function RandomPlayer.New(space, color)
  Ass.Is(space, 'Space')
  Ass.Is(color, Color)
  local self =
  {
    space = space,
    color = color
  }
  return setmetatable(self, RandomPlayer)
end
--
function RandomPlayer:__tostring()
  return 'random_player['..tostring(self.color)..']'
end
--
function RandomPlayer:move(color)
  if color == self.color then
    timer.performWithDelay(100, function() self:move_async() end)
  end
end
--
function RandomPlayer:move_async()
  local attempts = 1000

  -- do something until can move
  while self.space:who_move() == self.color do
    -- select random piece of my color
    local from = Vec.Random(Vec.Zero, self.space.size - Vec.One)
    local piece = self.space:piece(from)
    if piece ~= nil and piece.color == self.color then
      -- execute random ability
      local ability = map.random(piece.abilities)
      if ability then
        piece:use_ability(tostring(ability))
      end
      -- move to random point
      local to = from + Vec.Random(Vec.Zero-Vec.One, Vec.One)
      if self.space:can_move(from, to) then
        self.space:move(from, to)
      end
    end

    attempts = attempts - 1
    if attempts <= 0 then
      log:trace('cannot find move')
      break
    end
  end
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(RandomPlayer, 'move', Color)
Ass.Wrap(RandomPlayer, 'move_async')

log:wrap(RandomPlayer, 'move', 'move_async')

return RandomPlayer