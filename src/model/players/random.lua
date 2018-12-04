local map     = require 'src.core.map'
local Ass     = require 'src.core.Ass'
local log     = require 'src.core.log'
local Vec     = require 'src.core.vec'
local object  = require 'src.core.object'
local Color   = require 'src.model.Color'
local Ability = require 'src.model.Ability'

--
local random = object:new()

-- create
function random:create(space, color)
  Ass.Is(space, 'Space')
  Ass.Is(color, Color)
  return random:new({space = space, color = color})
end
--
function random:__tostring()
  return 'random_player['..tostring(self.color)..']'
end
--
function random:move(color)
  if color == self.color then
    timer.performWithDelay(100, function() self:move_async() end)
  end
end
--
function random:move_async()
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
Ass.Wrap(random, ':move', Color)
Ass.Wrap(random, ':move_async')

log:wrap(random, 'move', 'move_async')

return random