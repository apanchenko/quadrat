local widget    = require 'widget'
local arr       = require 'src.core.arr'
local vec       = require 'src.core.vec'
local cfg       = require 'src.model.cfg'
local lay       = require 'src.core.lay'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local obj       = require 'src.core.obj'
local typ       = require 'src.core.typ'
local wrp       = require 'src.core.wrp'

local stoneAbilities = obj:extend('stoneAbilities')

-- A set of abilities a piece have.
function stoneAbilities:new(stone, model)
  return obj.new(self,
  {
    _list = {}, -- list of abilities
    _stone = stone, -- owner
    _model = model,
    _mark = nil -- image marking that piece have abilities
  })
end
--
function stoneAbilities:__tostring() 
  return "abilities"
end

-------------------------------------------------------------------------------
-- add ability
function stoneAbilities:set_count(id, count)
  ass.ge(count, 0)

  if count == 0 then
    self._list[id] = nil
  else
    self._list[id] = count
  end

  if count > 0 and self._mark == nil then
    cfg.cell.path = "src/view/ability_"..tostring(self._stone:color())..".png"
    cfg.cell.order = 1
    self._mark = lay.image(self._stone, cfg.cell)
  end

  local reshow = self._view ~= nil

  if reshow then
    self:hide()
  end

  if self:is_empty() then
    self._mark:removeSelf()
    self._mark = nil
  else
    if reshow then
      self:show()
    end
  end
end

-- return true if empty
function stoneAbilities:is_empty()
  return arr.is_empty(self._list)
end

-- show on board
function stoneAbilities:show()
  assert(self.view == nil)                 -- check is hidden now
  self._view = display.newGroup()

  for name, count in pairs(self._list) do     -- create new button
    local opts = cfg.abilities.button
    opts.id = name
    opts.label = name
    if count > 1 then
      opts.label = opts.label.. ' '.. count
    end
    opts.onRelease = function(event)
      self._model:use(self._stone:pos(), event.target.id)
      return true
    end
    --log:trace(opts.label)
    --lay.render(self._view, widget.newButton(opts), cfg.origin)
    lay.button(self._view, opts)
  end
  --lay.column(self._view, 3)
  lay.rows(self._view, cfg.abilities.rows)
  lay.render(self._stone.board.battle, self._view, cfg.abilities)
end

-- hide from board when piece deselected
function stoneAbilities:hide()
  if self._view then -- check shown
    self._view:removeSelf()
    self._view = nil
  end
end

--
function stoneAbilities.wrap()
  wrp.fn(stoneAbilities, 'new', {{'stone'}, {'space'}})
  wrp.fn(stoneAbilities, 'set_count', {{'id', typ.str}, {'count', typ.num}})
  wrp.fn(stoneAbilities, 'is_empty', {log=log.info})
  wrp.fn(stoneAbilities, 'show')
  wrp.fn(stoneAbilities, 'hide')
end

--
return stoneAbilities