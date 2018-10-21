local cfg = require 'src.Config'
local ass = require 'src.core.ass'
local log = require 'src.core.log'

lay = {}

--[[-----------------------------------------------------------------------------
group   display group insert in
obj     display object to render
opts:
  vx    defaults to 0
  vy    defaults to 0
-----------------------------------------------------------------------------]]--
local function render(target, obj, opts)
  ass.table(target, "target")
  ass.table(obj, "object")
  ass.table(opts, "opts")

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

--[[-----------------------------------------------------------------------------
-----------------------------------------------------------------------------]]--
local function column(obj)
  view = obj.view or obj
  local y = 0
  for i = 1, view.numChildren do
    local child = view[i]
    child.y = y
    y = y + child.height
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
  ass.table(opts, "opts")

  path = path or opts.path
  ass.string(path, 'path')
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

--[[-----------------------------------------------------------------------------
group   display group insert in
opts:
  text  text to render
  vx    optional, defaults to 0
  vy    optional, defaults to 0
  fontSize
-----------------------------------------------------------------------------]]--
function lay.text(group, opts)
  ass.table(opts, "opts")

  if opts.font == nil then
    opts.font = cfg.font                    -- select default font
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