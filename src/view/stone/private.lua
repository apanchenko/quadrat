local cfg = require('src.cfg')
local lay = require('src.lua-cor.lay')
local vec = require('src.lua-cor.vec')
local ass = require('src.lua-cor.ass')
local map = require('src.lua-cor.map')
local log = require('src.lua-cor.log').get('view')

local _ = {}

-- variables ------------------------------------------------------------------
_.abilities = {}
_.ability_view = {}
_.view = {}
_.battle_view = {}
_.asset = {}
_.move_pid = {} -- moving side

-- functions ------------------------------------------------------------------
--
_.update_aura = function(self)
  if _.is_abilities_empty(self) then
    self[_.view].hide('aura_white')
    self[_.view].hide('aura_black')
  else
    self[_.view].show('aura_'..tostring(self:get_pid()))
  end
end

--
_.active_changed = function(self)
  local pid = self:get_pid()
  local my_active_view = 'active_'..tostring(pid)
  if pid == self[_move_pid] then
    self[_.view].show(my_active_view)
  else
    self[_.view].hide(my_active_view)
  end
end

--
_.update_pid = function(self, pid)
  self[_.view].show(tostring(pid))
  _.update_aura(self)
  _.active_changed(self)
end

--
_.update_group_pos = function(self, pos)
  -- remove from board
  if pos == nil then
    self._pos = nil
    self[_.view].x = 0
    self[_.view].y = 0
    return
  end

  -- calculate new view position
  local view_pos = pos * cfg.view.cell.size
  if self.isSelected then
    view_pos.y = view_pos.y - 10
  end

  if self._pos then
    log.info('animate to view position', view_pos)
    lay.to(self[_.view], view_pos, cfg.view.stone.move)
  else
    log.info('instant set view position', view_pos)
    view_pos:to(self[_.view])
  end
  self._pos = pos
end

-- show on board
_.show_abilities = function(self)
  ass.nul(self[_.ability_view])                 -- check is hidden now
  self[_.ability_view] = display.newGroup()

  for name, count in pairs(self[_.abilities]) do     -- create new button
    local opts = cfg.view.abilities.button
    opts.id = name
    opts.label = name
    if count > 1 then
      opts.label = opts.label.. ' '.. count
    end
    opts.onRelease = function(event)
      self[_.asset]:use_jade(event.target.id)
      return true
    end
    --log.trace(opts.label)
    lay.new_button(self[_.ability_view], opts)
  end
  lay.rows(self[_.ability_view], cfg.view.abilities.rows)
  lay.insert(self[_.battle_view], self[_.ability_view], cfg.view.abilities)
end

-- hide from board when piece deselected
_.hide_abilities = function(self)
  if self[_.ability_view] then -- check shown
    self[_.ability_view]:removeSelf()
    self[_.ability_view] = nil
  end
end

--
_.create_project = function(self, proj)
  if not self.project then
    cfg.view.cell.path = "images/board/project_"..tostring(self:get_pid())..".png"
    self.project = lay.new_image(self.board.view, cfg.view.cell)
  end
  self.proj = proj
  vec.copy(proj * cfg.view.cell.size, self.project)
end

--
_.remove_project = function(self)
  if self.project then
    self.project:removeSelf()
    self.project = nil
  end
  self.proj = nil
end

--
_.set_drag = function(self, eventId)
  display.getCurrentStage():setFocus(self[_.view], eventId)
  self.is_drag = (eventId ~= nil)
  if self.is_drag then
    --lay.render(self.board, self, {x=self.view.x, y=self.view.y})
    self[_.view]:toFront()
  end
end

-- return true if empty
_.is_abilities_empty = function(self)
  return map.count(self[_.abilities]) == 0
end


return _