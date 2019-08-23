local areal = require('src.model.power.areal')
local ass   = require('src.lua-cor.ass')
local arr   = require('src.lua-cor.arr')
local log   = require('src.lua-cor.log').get('mode')
local wrp   = require('src.lua-cor.wrp')
local typ   = require('src.lua-cor.typ')

local scramble = areal:extend('Scramble')


-- can spawn in jade
-- @override
function scramble:can_spawn()
  return true
end

-- @override
function scramble:apply_to_spot(spot)
  -- put piece info a bag
  local piece = spot.piece
  if piece then
    if self.stash == nil then
      self.stash = arr()
    end
    spot:stash_piece(self.stash) -- put piece into stash
  end

  -- remember spot
  if spot:can_set_piece() and (spot.jade == nil) then
    if self.spots == nil then
      self.spots = arr()
    end
    self.spots:push(spot)
  end
end
function scramble:apply_to_spot_after(spot)
  if self.stash and self.spots then
    ass.le(#self.stash, #self.spots)
  end
end

-- @override
function scramble:apply_finish()
  while not self.stash:is_empty() do
    local spot = self.spots:remove_random()
    spot:unstash_piece(self.stash)
  end
  self.stash = nil
end

-- MODULE ---------------------------------------------------------------------
function scramble:wrap()
  wrp.fn(log.info, scramble, 'can_spawn', scramble)
end

return scramble