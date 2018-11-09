local _         = require 'src.core.underscore'
local widget    = require "widget"
local vec       = require "src.core.Vec"
local Ability   = require "src.battle.powers.Ability"
local Color     = require 'src.model.Color'
local cfg       = require 'src.Config'
local lay       = require 'src.core.lay'
local Ass       = require 'src.core.Ass'
local log       = require 'src.core.log'
local Type      = require 'src.core.Type'

local PieceAbilities = Type.Create 'PieceAbilities'

-- A set of abilities a piece have.
function PieceAbilities.New(stone)
  Ass.Is(stone, 'Stone')
  local self = setmetatable({}, PieceAbilities)
  self.list = {} -- list of abilities
  self.piece = stone -- owner piece
  self.mark = nil -- image marking that piece have abilities
  return self
end

-- pairs (name, ability) to iterate
function PieceAbilities:pairs()
  return pairs(self.list)
end

-- add random ability
function PieceAbilities:add_random()
  local depth = log:trace(self, ":add_random"):enter()
    self:learn(Ability.new())
  log:exit(depth)
end

-- learn certain ability
function PieceAbilities:learn(ability)
  Ass.Is(ability, "Ability")
  local depth = log:trace(self, ":learn ", ability):enter()
    local name = tostring(ability)
    if self.list[name] then
      self.list[name]:increase(ability.count)
    else
      self.list[name] = ability
    end

    -- add ability mark
    if self.mark == nil then
      cfg.cell.order = 1
      self.mark = lay.image(self.piece, cfg.cell, "src/battle/ability_".. tostring(self.piece.color).. ".png")
      cfg.cell.order = nil
    end
    
  log:exit(depth)
end

-- pairs (name, ability) to iterate
function PieceAbilities:pairs()
  return pairs(self.list)
end

-- add ability
function PieceAbilities:add(name)
  if self.list[name] then
    self.list[name]:increase(1)
  else
    self.list[name] = ability
  end
  -- add ability mark
  if self.mark == nil then
    cfg.cell.order = 1
    self.mark = lay.image(self.piece, cfg.cell, "src/battle/ability_".. tostring(self.piece:color()).. ".png")
    cfg.cell.order = nil
  end
end

-- return true if empty
function PieceAbilities:is_empty()
  return _.is_empty(self.list)
end

-- use instant ability or create power
function PieceAbilities:use(name)
  local ability = self.list[name]
  self.list[name] = ability:decrease()
  self.piece:add_power(ability)                   -- increase power
  self.piece.board:select(nil)                  -- remove selection if was selected
end


-- MODULE ---------------------------------------------------------------------
Ass.Wrap(PieceAbilities, 'use', 'string')

log:wrap(PieceAbilities, 'use')

return PieceAbilities