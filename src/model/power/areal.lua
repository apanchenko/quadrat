local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local typ       = require 'src.core.typ'
local wrp       = require 'src.core.wrp'
local power     = require 'src.model.power.power'

-- areal power
local areal = power:extend('areal')
areal.is_areal = true

-- create an areal power that sits on onwer piece and acts once or more times
-- @param piece - apply power to this piece
-- @param zone - area power applyed to
function areal:new(piece, def, zone)
  def.zone = zone
  self = power.new(self, piece, def)

  -- specify spell area rooted from piece
  local area = zone:new(self.piece.pos)
  -- select spots in area
  local spots = self.piece.space:select_spots(function(spot) return area:filter(spot.pos) end)
  -- apply to each selected spot
  for i = 1, #spots do
    local spot = spots[i]
    self:apply_to_spot(spot)

    local spot_piece = spot.piece
    if spot_piece then
      if spot_piece == self.piece then
        self:apply_to_self()
      else
        if spot_piece.pid == self.piece.pid then
          self:apply_to_friend(spot_piece)
        else
          self:apply_to_enemy(spot_piece)
        end
      end
    end
  end
  -- return nothing
end

--
function areal:apply_to_spot(spot) end
function areal:apply_to_self() end
function areal:apply_to_friend(piece) end
function areal:apply_to_enemy(piece) end

--
function areal.wrap()
  local piece = {'piece'}
  wrp.fn(areal, 'new', {piece, {'def', typ.tab}, {'zone', typ.tab}})
  wrp.fn(areal, 'apply_to_spot', {{'spot'}})
  wrp.fn(areal, 'apply_to_self')
  wrp.fn(areal, 'apply_to_friend', {piece})
  wrp.fn(areal, 'apply_to_enemy', {piece})
end

return areal