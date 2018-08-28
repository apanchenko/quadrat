local widget = require "widget"
local Pos    = require "src.core.Pos"
local cfg    = require "src.Config"
local ass    = require "src.core.ass"
local PowerMoveDiagonal = require "src.battle.PowerMoveDiagonal"
local PowerMultiply     = require "src.battle.PowerMultiply"


local Powers = {PowerMoveDiagonal, PowerMultiply}

Abilities = {}
Abilities.__index = Abilities
setmetatable(Abilities, {__call = function(cls, ...) return cls.new(...) end})
function Abilities:__tostring() return "abilities" end

--[[---------------------------------------------------------------------------
A set of abilities a piece have. To be shown for selected piece.
---------------------------------------------------------------------------]]--
function Abilities.new(ability_listener)
  local self = setmetatable({}, Abilities)
  self.list = {0, 0}

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
  print(tostring(self)..":add " .. Powers[i].name())
end

-------------------------------------------------------------------------------
-- show on board
function Abilities:show(battle_group)
  print(tostring(self) .. ":show")
  assert(self.view == nil)                 -- check is hidden now
  self.view = display.newGroup()

  for i=1, #self.list do     -- create new button
    if self.list[i] > 0 then
      local opts = cfg.abilities.button
      opts.id = i
      opts.label = Powers[i].name() .. " " .. self.list[i]
      opts.onRelease = function(event)
        self:_use(event)
        return true
      end
      print("  " .. opts.label)
      lib.render(self, widget.newButton(opts), {})
    end
  end
  lib.column(self)
  lib.render(battle_group, self, cfg.abilities)
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
function Abilities:_use(event)
  local i = event.target.id
  self.list[i] = self.list[i] - 1
  self.ability_listener:use_ability(Powers[i])
  ass.natural(self.list[i])
end


return Abilities