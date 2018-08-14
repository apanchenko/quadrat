local Pos = require("src.core.Pos")
local cfg = require("src.Config")

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
function Abilities.new()
  local self = setmetatable({}, Abilities)
  self.list = {}
  return self
end

-------------------------------------------------------------------------------
-- add random ability
function Abilities:add()
  local name = Abilities.Diagonal           -- select new ability name
  local item = self:_find(name)
  if item == nil then
    table.insert(self.list, {name=name, count = 1})
  else
    item.count = item.count + 1
  end
end

-------------------------------------------------------------------------------
-- show on board
function Abilities:show(battle_group)
  assert(self.group == nil)                 -- check hidden
  self.group = display.newGroup()

  for name, item in ipairs(self.list) do    -- generate new texts
    local opts = {text=(item.name .. " x" .. item.count), fontSize=20}
    local text = lib.text(self.group, opts)
    text:addEventListener("touch", self)
  end

  lib.render(battle_group, self.group, cfg.abilities)
end

-------------------------------------------------------------------------------
-- hide from board
function Abilities:hide()
  assert(self.group)                        -- check shown
  self.group:removeSelf()
  self.group = nil
end

-------------------------------------------------------------------------------
-- touch listener function
function Abilities:touch(event)
  if event.phase == "began" then
    self.isFocus = true                     -- focus this ability

  elseif self.isFocus then

    if event.phase == "moved" then
    elseif event.phase == "ended" then
      self.isFocus = false                  -- focus lost
    elseif event.phase == "cancelled" then
      self.isFocus = false                  -- focus lost
    end
  end

  return true
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