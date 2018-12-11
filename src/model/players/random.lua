local map     = require 'src.core.map'
local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local Vec     = require 'src.core.vec'
local object  = require 'src.core.object'
local Color   = require 'src.model.Color'
local Ability = require 'src.model.Ability'

--
local random = object:extend('random')

-- create
random._create = object.create
function random:create(space, color)
  ass.is(color, Color)
  return self:_create({space = space, color = color})
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
    local from = Vec:random(Vec.zero, self.space.size - Vec.one)
    local piece = self.space:piece(from)
    if piece ~= nil and piece.color == self.color then
      -- execute random ability
      local ability = map.random(piece.abilities)
      if ability then
        piece:use_ability(tostring(ability))
      end
      -- move to random point
      local to = from + Vec:random(Vec.zero-Vec.one, Vec.one)
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
ass.wrap(random, ':move', Color)
ass.wrap(random, ':move_async')

log:wrap(random, 'move', 'move_async')

return random