local _         = require 'src.core.underscore'
local widget    = require "widget"
local vec       = require "src.core.Vec"
local Ability   = require "src.battle.powers.Ability"
local Color     = require 'src.model.Color'
local cfg       = require 'src.Config'
local lay       = require 'src.core.lay'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'

PieceAbilities = {}
PieceAbilities.__index = PieceAbilities
function PieceAbilities:__tostring() return "PieceAbilities" end

-- A set of abilities a piece have.
function PieceAbilities.new(stone)
  ass.is(stone, 'Stone')
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
  ass.is(ability, "Ability")
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
      self.mark = lay.image(self.piece, cfg.cell, "src/battle/ability_".. Color.string(self.piece.color).. ".png")
      cfg.cell.order = nil
    end
    
  log:exit(depth)
end

-- return true if empty
function PieceAbilities:is_empty()
  return _.is_empty(self.list)
end

-- show on board
function PieceAbilities:show(env)
  local depth = log:trace(self, ":show"):enter()
    assert(self.view == nil)                 -- check is hidden now
    self.view = display.newGroup()

    for name, ability in pairs(self.list) do     -- create new button
      local opts = cfg.abilities.button
      opts.id = name
      opts.label = name.. " ".. ability:get_count()
      opts.onRelease = function(event)
        self:use(event.target.id)
        return true
      end
      log:trace(opts.label)
      lay.render(self, widget.newButton(opts), {})
    end
    lay.column(self)
    lay.render(self.piece.board.battle, self, cfg.abilities)
  log:exit(depth)
end

-- hide from board when piece deselected
function PieceAbilities:hide()
  assert(self.view)                        -- check shown
  self.view:removeSelf()
  self.view = nil
end

-- use instant ability or create power
function PieceAbilities:use(name)
  local depth = log:trace(self, ":use_ability ", ability):enter()
    local ability = self.list[name]
    self.list[name] = ability:decrease()
    self.piece:add_power(ability)                   -- increase power
    self.piece.board:select(nil)                  -- remove selection if was selected

    -- remove ability mark
    if self:is_empty() and self.mark then
      log:trace("remove mark")
      self.mark:removeSelf()
      self.mark = nil
    end
  log:exit(depth)
end


return PieceAbilities