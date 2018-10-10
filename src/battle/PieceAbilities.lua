local _         = require 'src.core.underscore'
local widget    = require "widget"
local vec       = require "src.core.vec"
local Ability   = require "src.battle.powers.Ability"
local cfg       = require 'src.Config'
local lay       = require 'src.core.lay'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'

PieceAbilities = {}
PieceAbilities.__index = PieceAbilities
function PieceAbilities:__tostring() return "PieceAbilities" end

-- A set of abilities a piece have.
function PieceAbilities.new(piece)
  ass.is(piece, "Piece")
  local self = setmetatable({list={}, piece=piece}, PieceAbilities)
  return self
end

-- add random ability
function PieceAbilities:add(env)
  local depth = log:trace(self, ":add"):enter()
    local ability = Ability.new()
    local name = tostring(ability)
    if self.list[name] then
      self.list[name]:increase()
    else
      self.list[name] = ability
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
  local ability = self.list[name]
  self.list[name] = ability:decrease()
  self.piece:use_ability(ability)
end


return PieceAbilities