local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('mode')
local typ       = require 'src.lua-cor.typ'
local wrp       = require 'src.lua-cor.wrp'
local power     = require 'src.model.power.power'

-- areal power
local areal = power:extend('areal')
areal.is_areal = true

--
function areal:wrap()
  local piece = {'piece'}
  local spot  = {'spot'}
  local def   = {'def', typ.tab}
  local zone  = {'zone', typ.tab}

  wrp.wrap_tbl(log.trace, areal, 'new',             piece, def, zone)
  wrp.wrap_sub(log.trace, areal, 'apply_to_spot',   spot            )
  wrp.wrap_sub(log.trace, areal, 'apply_to_self'                    )
  wrp.wrap_sub(log.trace, areal, 'apply_to_friend', spot            )
  wrp.wrap_sub(log.trace, areal, 'apply_to_enemy',  spot            )
  wrp.wrap_sub(log.trace, areal, 'apply_finish'                     )
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