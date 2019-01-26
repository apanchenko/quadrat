local cfg = require 'src.cfg'
local ass = require 'src.core.ass'
local log = require 'src.core.log'

lay = {}

--[[-----------------------------------------------------------------------------
target  display group insert in
obj     display object to render
opts:
  vx    defaults to 0
  vy    defaults to 0
-------------------------------------------------------------------------------]]
local function render(target, obj, opts)
  ass.tab(target, "target")
  ass.tab(obj, "object")
  ass.tab(opts, "opts")

  target = target.view or target
  child = obj.view or obj
  child.anchorX = opts.anchorX or 0
  child.anchorY = opts.anchorY or 0
  child.x = opts.x or (cfg.vw * (opts.vx or 0))
  child.y = opts.y or (cfg.vh * (opts.vy or 0))

  if opts.vw then
    local scale = cfg.vw * opts.vw / obj.width
    child:scale(scale, scale)
  end

  if opts.order == nil then
    target:insert(child)
  else
    target:insert(opts.order, child)
  end

  return obj
end
lay.render = render

-- animate coordinates
function lay.to(obj, pos, params)
  params.x = pos.x
  params.y = pos.y
  transition.to(obj.view, params)
end

-- arrange children in column
local function column(obj, space)
  local view = obj.view or obj
  space = space or 0
  local y = 0
  for i = 1, view.numChildren do
    local child = view[i]
    child.y = y
    y = y + child.height + space
  end
end 
lay.column = column

--[[-----------------------------------------------------------------------------
group   display group insert in
path    path to image resource
opts:
  w     width in px
  vw    or width in vw
  h     height in px
  hw    or height in vh
  ratio or height relative to width
  vx    defaults to 0
  vy    defaults to 0
-----------------------------------------------------------------------------]]--
function lay.image(group, opts, path)
  ass.tab(opts, "invalid opts")

  path = path or opts.path
  ass.str(path, 'path')
  --log:trace("lay.image ".. path)

  local w = opts.w or (cfg.vw * opts.vw)

  local h;
  if opts.h then
    h = opts.h
  elseif opts.vh then
    h = cfg.vh * opts.vh
  else
    h = w / (opts.ratio or 1)
  end

  local img = display.newImageRect(path, w, h)
  
  render(group, img, opts)
  return img
end

-- Display text
-- @param group   display group insert in
-- @param opts = {text, vx, vy, x, y, width, height, font, fontSize}
-- @see https://docs.coronalabs.com/api/library/display/newText.html
function lay.text(group, opts)
  ass.tab(opts, "opts")

  if opts.font == nil then
    opts.font = cfg.font -- select default font
  end

  if opts.w then
    opts.width = opts.w
  elseif opts.vw then
    opts.width = opts.vw * cfg.vw
  end

  local text = display.newText(opts)
  
  render(group, text, opts)
  return text
end

-------------------------------------------------------------------------------
function lay.sheet(group, sheet, frame, opts)
  assert(sheet)
  assert(frame)
  assert(opts.w and opts.h)
  local img = display.newImageRect(sheet, frame, opts.w, opts.h)
  render(group, img, opts)
  return img
end


return lay