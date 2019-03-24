local areal     = require 'src.model.power.areal'
local ass       = require 'src.core.ass'
local arr       = require 'src.core.arr'

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
      self.stash = {}
    end
    spot:stash_piece(self.stash) -- put spot into stash
  end

  -- remember spot
  if spot:can_set_piece() and (spot.jade == nil) then
    if self.spots == nil then
      self.spots = {}
    end
    arr.push(self.spots, spot)
  end
end

-- @override
function scramble:apply_finish()
  while not arr.is_empty(self.stash) do
    local spot = arr.remove_random(self.spots)
    spot:unstash_piece(self.stash)
  end
  self.stash = nil
end

return scramble