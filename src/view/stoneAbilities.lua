local widget    = require 'widget'
local arr       = require 'src.lua-cor.arr'
local vec       = require 'src.lua-cor.vec'
local cfg       = require 'src.cfg'
local lay       = require 'src.lua-cor.lay'
local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('')
local obj       = require 'src.lua-cor.obj'
local typ       = require 'src.lua-cor.typ'
local wrp       = require 'src.lua-cor.wrp'
local env       = require 'src.lua-cor.env'
local map       = require 'src.lua-cor.map'

local stoneAbilities = obj:extend('stoneAbilities')

-- A set of abilities a piece have.
function stoneAbilities:new(stone)
  return obj.new(self,
  {
    _list = {}, -- list of abilities
    _stone = stone, -- owner
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

  if count > 0 then
    local pid = self._stone:get_pid()
    self._stone._view.show('ability_'..tostring(pid))
  end

  local reshow = self._view ~= nil

  if reshow then
    self:hide()
  end

  if self:is_empty() then
    self._stone._view.hide('ability_white')
    self._stone._view.hide('ability_black')
  else
    if reshow then
      self:show()
    end
  end
end

-- return true if empty
function stoneAbilities:is_empty()
  return map.count(self._list) == 0
end

-- show on board
function stoneAbilities:show()
  assert(self.view == nil)                 -- check is hidden now
  self._view = display.newGroup()

  for name, count in pairs(self._list) do     -- create new button
    local opts = cfg.view.abilities.button
    opts.id = name
    opts.label = name
    if count > 1 then
      opts.label = opts.label.. ' '.. count
    end
    opts.onRelease = function(event)
      env.space:use(self._stone:pos(), event.target.id)
      return true
    end
    --log.trace(opts.label)
    lay.new_button(self._view, opts)
  end
  --lay.column(self._view, 3)
  lay.rows(self._view, cfg.view.abilities.rows)
  lay.insert(env.battle.view, self._view, cfg.view.abilities)
end

-- hide from board when piece deselected
function stoneAbilities:hide()
  if self._view then -- check shown
    self._view:removeSelf()
    self._view = nil
  end
end

--
function stoneAbilities:wrap()
  wrp.wrap_tbl(log.trace, stoneAbilities, 'new',       {'stone'})
  wrp.wrap_sub(log.trace, stoneAbilities, 'set_count', {'id', typ.str}, {'count', typ.num})
  wrp.wrap_sub(log.info, stoneAbilities, 'is_empty')
  wrp.wrap_sub(log.trace, stoneAbilities, 'show')
  wrp.wrap_sub(log.trace, stoneAbilities, 'hide')
end

--
return stoneAbilities