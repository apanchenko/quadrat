local widget   = require "widget"
local composer = require "composer"

local scene = composer.newScene()
local platform = system.getInfo( "platform" )

-------------------------------------------------------------------------------
-- button handler
local function handle_button(next_scene)
    print("menu:handle_button "..next_scene)
    if next_scene == "exit" then
        native.requestExit()
    else
        composer.gotoScene(next_scene, {effect="fade", time=600})
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
        onPress = function(event) return handle_button(event.target.id) end,
        emboss = false,
        font = native.systemFont,
        fontSize = 17,
        shape = "roundedRect",
        width = 250,
        height = 32,
        cornerRadius = 9,
        fillColor   = { default = {0.6, 0.7, 0.8, 1}, over = {0.6, 0.7, 0.8, 0.8} },
        labelColor  = { default = {1.0, 1.0, 1.0, 1}, over = {1.0, 1.0, 1.0, 1.0} },
        strokeColor = { default = {1.0, 0.4, 0.0, 1}, over = {0.8, 0.8, 1.0, 1.0} },
        strokeWidth = 0
    }
end

-------------------------------------------------------------------------------
function scene:create(event)

    local back = display.newImageRect(self.view, "src/background.png", display.contentWidth, display.contentHeight)
    back.anchorX = 0
    back.anchorY = 0

    local buttonGroup = display.newGroup()

    buttonGroup:insert(new_button("src.Battle", "Play"))

    if (platform ~= "ios" and platform ~= "tvos") then
        buttonGroup:insert(new_button("exit", "Exit"))
    end
    
    buttonGroup.y = buttonGroup.contentHeight / 2 + 45
    self.view:insert(buttonGroup)
end

-------------------------------------------------------------------------------
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end

-------------------------------------------------------------------------------
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end
 
 
-------------------------------------------------------------------------------
-- destroy()
function scene:destroy( event )
    print("scene:destroy")
   local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene