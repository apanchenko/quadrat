local cfg = require 'src.model.cfg'
local ass = require 'src.core.ass'
local log = require 'src.core.log'
local typ = require 'src.core.typ'
local arr = require 'src.core.arr'
local wrp = require 'src.core.wrp'
local map = require 'src.core.map'
local widget = require 'widget'

local lay = {}

-- wrap interface
function lay.wrap()
  local wrap = function(name, ...)
    wrp.fn(lay, name, {...}, {name='lay', static=true, log=log.info})
  end
  local target = {'target', typ.tab}
  local obj    = {'object', typ.tab}
  local opts   = {'opts', typ.tab, map.tostring}
  local pos    = {'pos', typ.tab}
  local space  = {'space', typ.num}

  wrap('render', target,  obj, opts)
  wrap('to',     obj,     pos, opts)
  wrap('image',  target,  opts)
  wrap('column', obj,     space)
  wrap('rows',   obj,     opts)
end


-- @param target          display group insert in
-- @param obj             object to render
-- @param opts.w          width in pixels
-- @param opts.vw         or width in vw
-- @param opts.h          height in pixels
-- @param opts.hw         or height in vh
-- @param opts.ratio      or height relative to width
-- @param opts.vx         defaults to 0
-- @param opts.vy         defaults to 0
-- @param opts.order      render order, 1 renders first, larger renders later
function lay.render(target, obj, opts)
  ass(opts.x or opts.vx, 'lay.render - set opts x or vx')
  ass(opts.y or opts.vy, 'lay.render - set opts y or vy')
  target = target.view or target
  child = obj.view or obj
  child.anchorX = opts.anchorX or 0
  child.anchorY = opts.anchorY or 0
  child.x = opts.x or (cfg.vw * opts.vx)
  child.y = opts.y or (cfg.vh * opts.vy)

  if opts.vw then
    local scale = cfg.vw * opts.vw / obj.width
    child:scale(scale, scale)
  end

  -- calculate group index by order
  ass.num(target.numChildren)
  local next = target.numChildren + 1
  child.order = opts.order or next
  local index = arr.find_index(target, 1, next, child, function(a, b)
    ass.num(a.order, 'order not set in '..tostring(a))
    ass.num(b.order, 'order not set in '..tostring(b))
    return a.order < b.order
  end)
  target:insert(index, child)
  return obj
end

-- animate coordinates
function lay.to(obj, pos, params)
  params.x = pos.x
  params.y = pos.y
  transition.to(obj.view, params)
end

-- arrange children in column
function lay.column(obj, space)
  local view = obj.view or obj
  local y = 0
  for i = 1, view.numChildren do
    local child = view[i]
    child.y = y
    y = y + child.height + space
  end
end

-- Arrange children in rows. Children should be of same height.
-- @param opts:
--    length        maximum length or each row
--    space_x       horizontal space between elements in a row
--    space_y       vertical space between rows
function lay.rows(obj, opts)
  local view = obj.view or obj
  local space_x = opts.space_x or (cfg.vw * opts.space_px)
  local space_y = opts.space_y or (cfg.vw * opts.space_py)
  local x = 0
  local y = 0
  local count = 0
  for i = 1, view.numChildren do
    local child = view[i]
    child.x = x
    child.y = y
    --log:trace('child '..tostring(i)..': '..tostring(x)..'x'..tostring(y))
    x = x + child.width + space_x
    count = count + 1
    if count == opts.length then
      count = 0
      x = 0
      y = y + child.height + space_y
    end
  end
end 

-- group      display group insert in
-- opts       @see render
-- path       path to image resource
function lay.image(group, opts)
  ass.tab(opts, "invalid opts")

  ass.str(opts.path, 'path')

  local w = opts.w or (cfg.vw * opts.vw)

  local h;
  if opts.h then
    h = opts.h
  elseif opts.vh then
    h = cfg.vh * opts.vh
  else
    h = w / (opts.ratio or 1)
  end

  local img = display.newImageRect(opts.path, w, h)
  lay.render(group, img, opts)
  return img
end

-- Display text
-- @param group   display group insert in
-- @param opts = {text, vx, vy, x, y, width, height, font, fontSize}
-- @see https://docs.coronalabs.com/api/library/display/newText.html
function lay.text(group, opts)
  if opts.font == nil then
    opts.font = cfg.font -- select default font
  end

  if opts.w then
    opts.width = opts.w
  elseif opts.vw then
    opts.width = opts.vw * cfg.vw
  end

  local text = display.newText(opts)
  lay.render(group, text, opts)
  return text
end

-- Create button
-- @see https://docs.coronalabs.com/api/library/widget/newButton.html
-- @param opts:
--    label         optional String. Text label that will appear on top of the button.
--    labelAlign    optional String. Alignment of the button label. Valid
--                    values are left, right, or center. Default is center.
--    labelColor    optional Table. Table of two RGBA color settings,
--                    one each for the default and over states. {default={1, 1, 1}, over={0, 0, 0, 0.5}}
--    labelXOffset  optional Number. x offset for the button label.
--    labelYOffset  optional Number. y offset for the button label.
--    font          optional String. Font used for the button label. Default is native.systemFont.
--    fontSize      optional Number. Font size (in pixels) for the button label. Default is 14.
--    emboss        optional Boolean. If set to true, the button label will appear embossed (inset effect).
--    textOnly      optional Boolean. If set to true, the button will be
--                    constructed via a text object only (no background element). Default is false.
--
--    shape         required String. "rect" | "roundedRect" | "circle" | "polygon"
--    fillColor     optional Table. Table of two RGBA color settings, one each
--                    for the default and over states. These colors define the
--                    fill color of the shape. {default={1, 0.2, 0.5, 0.7}, over={ 1, 0.2, 0.5, 1}}
--    strokeColor   optional Table. Table of two RGBA color settings, one each
--                    for the default and over states. These colors define the stroke color of the shape.
--                    {default={ 0, 0, 0 }, over={0.4, 0.1, 0.2}}
--    strokeWidth   optional Number. The width of the stroke around the shape
--                    object. Applies only if strokeColor is defined.
--    width, height optional Numbers. The width and height of the button shape.
--                    Only applies to "rect" or "roundedRect" shapes.
--    cornerRadius  optional Number. Radius of the curved corners for
--                    a "roundedRect" shape. This value is ignored for all other shapes.
--    radius        optional Number. Radius for a "circle" shape.
--                    This value is ignored for all other shapes.
--    vertices      optional Array. An array of x and y coordinates to define a "polygon" shape.
--                    These coordinates will automatically be re-centered about
--                    the center of the polygon, and the polygon will be centered
--                    in relation to the button label. This property is ignored for
--                    all other shapes. {-20, -25, 40, 0, -20, 25}
function lay.button(group, opts)
  if opts.width == nil then
    opts.width = cfg.vw * opts.vw
  end

  if opts.height == nil then
    if opts.vh then
      opts.height = cfg.vh * opts.vh
    else
      opts.height = w / (opts.ratio or 1)
    end
  end

  local button = widget.newButton(opts)
  lay.render(group, button, opts)
  return button
end

-------------------------------------------------------------------------------
function lay.sheet(group, sheet, frame, opts)
  assert(sheet)
  assert(frame)
  assert(opts.w and opts.h)
  local img = display.newImageRect(sheet, frame, opts.w, opts.h)
  lay.render(group, img, opts)
  return img
end

--
function lay.test()
end

return lay