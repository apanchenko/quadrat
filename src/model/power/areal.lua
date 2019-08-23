local power     = require('src.model.power.power')

-- areal power
local areal = power:extend('areal')
areal.is_areal = true

--
function areal:wrap()
  local log   = require('src.lua-cor.log').get('mode')
  local typ   = require('src.lua-cor.typ')
  local wrp   = require('src.lua-cor.wrp')
  local spot = require('src.model.spot.spot')
  local piece = require('src.model.piece.piece')
  local ex = typ.new_ex(areal)

  wrp.fn(log.trace, areal, 'new',             areal, piece, typ.tab, typ.tab)
  wrp.fn(log.trace, areal, 'apply_to_spot',   ex, spot            )
  wrp.fn(log.trace, areal, 'apply_to_self',   ex                )
  wrp.fn(log.trace, areal, 'apply_to_friend', ex, spot            )
  wrp.fn(log.trace, areal, 'apply_to_enemy',  ex, spot            )
  wrp.fn(log.trace, areal, 'apply_finish',    ex                 )
end

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
          self:apply_to_friend(spot)
        else
          self:apply_to_enemy(spot)
        end
      end
    end
  end

  self:apply_finish()
  -- return nothing
end

--
function areal:apply_to_spot(spot) end
function areal:apply_to_self() end
function areal:apply_to_friend(spot) end
function areal:apply_to_enemy(spot) end
function areal:apply_finish() end

return areal