local widget = require "widget"
local Pos    = require "src.core.Pos"
local cfg    = require "src.Config"

Abilities =
{
  Diagonal = "Diagonal"
}
Abilities.__index = Abilities
setmetatable(Abilities, {__call = function(cls, ...) return cls.new(...) end})
function Abilities:__tostring() return "abilities" end

--[[---------------------------------------------------------------------------
A set of abilities a piece have. To be shown for selected piece.
Arguments:
Variables:
  group - display group
  list  - {name:String -> {count:Number, text:TextObject}}
Methods:
  add() - adds new random ability
---------------------------------------------------------------------------]]--
function Abilities.new(ability_listener)
  local self = setmetatable({}, Abilities)
  self.list = {}

  assert(ability_listener)
  assert(ability_listener.use_ability)
  self.ability_listener = ability_listener      -- set ability listener

  return self
end

-------------------------------------------------------------------------------
-- add random ability
function Abilities:add()
  local name = Abilities.Diagonal           -- select new ability name
  local item = self:_find(name)
  if item == nil then
    table.insert(self.list, {name=name, count=1})
  else
    item.count = item.count + 1
  end
end

-------------------------------------------------------------------------------
-- show on board
function Abilities:show(battle_group)
  assert(self.group == nil)                 -- check hidden
  self.group = display.newGroup()

  for id, item in ipairs(self.list) do    -- generate new texts
    local opts = cfg.abilities.button
    opts.id = id
    opts.label = item.name .. " x" .. item.count
    opts.onRelease = function(event)
      self:_use(event)
      return true
    end
    lib.render(self.group, widget.newButton(opts), {})
  end

  lib.render(battle_group, self.group, cfg.abilities)
end

-------------------------------------------------------------------------------
-- hide from board
-- called from piece on deselect
function Abilities:hide()
  assert(self.group)                        -- check shown
  self.group:removeSelf()
  self.group = nil
end

-------------------------------------------------------------------------------
function Abilities:_use(event)
  local id = event.target.id
  local name = self.list[id].name
  print("Use ability " .. name)
  local count = self.list[id].count - 1
  if count == 0 then
    self.list[id] = nil                     -- delete last ability of a kind
  else
    self.list[id].count = count             -- decrease count
  end
  self.ability_listener:use_ability(name)
end

-------------------------------------------------------------------------------
-- touch listener function
function Abilities:_find(name)
  for i = 1, #self.list do
    if self.list[i].name == name then
      return self.list[i]
    end
  end
end


return Abilities