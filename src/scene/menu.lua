local widget    = require 'widget'
local composer  = require 'composer'
local log       = require('src.lua-cor.log').get('scen')
local lay       = require 'src.lua-cor.lay'
local cfg       = require 'src.scene.cfg'
local battle    = require 'src.scene.battle'
local lobby     = require 'src.scene.lobby'

local menu = composer.newScene()
local platform = system.getInfo('platform')

local options = {effect = 'fade', time = 600}

local layout = lay.new_layout()

layout.add_button = function(id, label, onPress, z)
  layout.add(id,
  {
    vx = 20,
    vy = 20,
    vw = 60,
    height = 32,
    id = id,
    label = label,
    onPress = onPress,
    emboss = false,
    font = native.systemFont,
    fontSize = 17,
    shape = 'roundedRect',
    cornerRadius = 9,
    fillColor   = {default = {0.6, 0.7, 0.8, 1}, over = {0.6, 0.7, 0.8, 0.8}},
    labelColor  = {default = {1.0, 1.0, 1.0, 1}, over = {1.0, 1.0, 1.0, 1.0}},
    strokeColor = {default = {1.0, 0.4, 0.0, 1}, over = {0.8, 0.8, 1.0, 1.0}},
    strokeWidth = 0,
    fn = lay.new_button,
    z = z
  })
  return layout
end

layout
  .add('bg', cfg.bg)
  .add_button('lobby', 'Play', lobby.goto_lobby, 2)
  .add_button('battle', 'Solo', battle.goto_solo, 3)
  .add_button('robots', 'Robots', battle.goto_robots, 4)
  .add_button('ai', 'AI', battle.goto_bot, 5)
  .add_button('exit', 'Exit', native.requestExit, 6)
  .add('version', {text=cfg.app.version, font=cfg.font, z=7, vx=0, vy=90, fn=lay.new_text})

-------------------------------------------------------------------------------
function menu:create(event)
  self.view = layout.new_group(self.view)
  self.view
    .show('lobby')
    .show('battle')
    .show('robots')
    .show('ai')
  if (platform ~= 'ios' and platform ~= 'tvos') then
    self.view.show('exit')
  end
  self.view
    .column(5)
    .show('bg')
    .show('version')
end

-------------------------------------------------------------------------------
function menu:show(event)
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
end

menu:addEventListener('create', menu)
menu:addEventListener('show', menu)
menu:addEventListener('hide', menu)
menu:addEventListener('destroy', menu)

return menu
