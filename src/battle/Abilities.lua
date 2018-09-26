local _      = require 'src.core.underscore'
local widget = require "widget"
local vec    = require "src.core.vec"
local cfg    = require "src.Config"
local ass    = require "src.core.ass"
local MoveDiagonal = require "src.battle.powers.MoveDiagonal"
local Multiply     = require "src.battle.powers.Multiply"
local Rehash       = require "src.battle.powers.Rehash"


local Powers = {MoveDiagonal, Multiply, Rehash}

Abilities = {}
Abilities.__index = Abilities
function Abilities:__tostring() return "abilities" end

--[[---------------------------------------------------------------------------
A set of abilities a piece have. To be shown for selected piece.
---------------------------------------------------------------------------]]--
function Abilities.new(log, ability_listener)
  local self = setmetatable({log=log}, Abilities)
  self.list = {0, 0, 0}

  assert(ability_listener)
  assert(ability_listener.use_ability)
  self.ability_listener = ability_listener      -- set ability listener

  return self
end

-------------------------------------------------------------------------------
-- add random ability
function Abilities:add()
  local i = math.random(#Powers)              -- select new power
  self.list[i] = self.list[i] + 1
  self.log:trace(self, ":add ", Powers[i].name())
end

-------------------------------------------------------------------------------
-- add random ability
function Abilities:is_empty()
  return _.reduce(self.list, 0, function(memo, i) return memo+i end) == 0
end
-------------------------------------------------------------------------------
-- show on board
function Abilities:show(battle_group)
  self.log:trace(self, ":show")
  assert(self.view == nil)                 -- check is hidden now
  self.view = display.newGroup()

  for i=1, #self.list do     -- create new button
    if self.list[i] > 0 then
      local opts = cfg.abilities.button
      opts.id = i
      opts.label = Powers[i].name() .. " " .. self.list[i]
      opts.onRelease = function(event)
        self:use(event)
        return true
      end
      print("  " .. opts.label)
      lay.render(self, widget.newButton(opts), {})
    end
  end
  lay.column(self)
  lay.render(battle_group, self, cfg.abilities)
end

-------------------------------------------------------------------------------
-- hide from board
-- called from piece on deselect
function Abilities:hide()
  assert(self.view)                        -- check shown
  self.view:removeSelf()
  self.view = nil
end

-------------------------------------------------------------------------------
function Abilities:use(event)
  local i = event.target.id
  self.list[i] = self.list[i] - 1
  self.ability_listener:use_ability(Powers[i])
  ass.natural(self.list[i])
end


return Abilities