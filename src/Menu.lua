local widget    = require 'widget'
local composer  = require 'composer'
local log       = require 'src.core.log'
local lay       = require 'src.core.lay'
local cfg       = require 'src.Config'

local menu = composer.newScene()
local platform = system.getInfo('platform')

-------------------------------------------------------------------------------
-- button handler
local function handle_button(next_scene)
  print('menu:handle_button ' .. next_scene)
  if next_scene == 'exit' then
    native.requestExit()
  else
    composer.gotoScene(next_scene, {effect = 'fade', time = 600})
  end
  return true
end

-------------------------------------------------------------------------------
-- create new button
local function new_button(id, label)
  return widget.newButton {
    x = display.contentCenterX,
    y = 0,
    id = id,
    label = label,
    onPress = function(event)
      return handle_button(event.target.id)
    end,
    emboss = false,
    font = native.systemFont,
    fontSize = 17,
    shape = 'roundedRect',
    width = 250,
    height = 32,
    cornerRadius = 9,
    fillColor = {default = {0.6, 0.7, 0.8, 1}, over = {0.6, 0.7, 0.8, 0.8}},
    labelColor = {default = {1.0, 1.0, 1.0, 1}, over = {1.0, 1.0, 1.0, 1.0}},
    strokeColor = {default = {1.0, 0.4, 0.0, 1}, over = {0.8, 0.8, 1.0, 1.0}},
    strokeWidth = 0
  }
end

-------------------------------------------------------------------------------
function menu:create(event)
  print('menu:new')
  lay.image(self.view, cfg.battle.bg)

  local buttons = display.newGroup()

  buttons:insert(new_button('src.lobby', 'Play'))
  buttons:insert(new_button('src.Battle', 'Solo'))

  if (platform ~= 'ios' and platform ~= 'tvos') then
    buttons:insert(new_button('exit', 'Exit'))
  end

  lay.column(buttons, 5)
  lay.render(self, buttons, {vy=15})
end

-------------------------------------------------------------------------------
function menu:show(event)
  print('menu:show')
  local sceneGroup = self.view
  local phase = event.phase

  if (phase == 'will') then
    -- Code here runs when the menu is still off screen (but is about to come on screen)
  elseif (phase == 'did') then
  -- Code here runs when the menu is entirely on screen
  end
end

-------------------------------------------------------------------------------
function menu:hide(event)
  local sceneGroup = self.view
  local phase = event.phase

  if (phase == 'will') then
    -- Code here runs when the menu is on screen (but is about to go off screen)
  elseif (phase == 'did') then
  -- Code here runs immediately after the menu goes entirely off screen
  end
end

-------------------------------------------------------------------------------
function menu:destroy(event)
  print('menu:destroy')
end

menu:addEventListener('create', menu)
menu:addEventListener('show', menu)
menu:addEventListener('hide', menu)
menu:addEventListener('destroy', menu)

return menu
