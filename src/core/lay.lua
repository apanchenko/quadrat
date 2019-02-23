local cfg = require 'src.model.cfg'
local ass = require 'src.core.ass'
local log = require 'src.core.log'
local typ = require 'src.core.typ'
local arr = require 'src.core.arr'
local wrp = require 'src.core.wrp'
local map = require 'src.core.map'


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
local function render(target, obj, opts)
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
  local next = target.numChildren + 1
  child.order = opts.order or next
  local index = arr.bsearch_range(target, 1, next, child, function(a, b)
    ass.num(a.order, 'order not set in '..tostring(a))
    ass.num(b.order, 'order not set in '..tostring(b))
    return a.order < b.order
  end)
  ass.num(index)
  target:insert(index, child)
  return obj
end

-- animate coordinates
local function to(obj, pos, params)
  params.x = pos.x
  params.y = pos.y
  transition.to(obj.view, params)
end

-- arrange children in column
local function column(obj, space)
  local view = obj.view or obj
  local y = 0
  for i = 1, view.numChildren do
    local child = view[i]
    child.y = y
    y = y + child.height + space
  end
end 

-- group      display group insert in
-- opts       @see render
-- path       path to image resource
local function image(group, opts)
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
  render(group, img, opts)
  return img
end

-- Display text
-- @param group   display group insert in
-- @param opts = {text, vx, vy, x, y, width, height, font, fontSize}
-- @see https://docs.coronalabs.com/api/library/display/newText.html
local function text(group, opts)
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
local function sheet(group, sheet, frame, opts)
  assert(sheet)
  assert(frame)
  assert(opts.w and opts.h)
  local img = display.newImageRect(sheet, frame, opts.w, opts.h)
  render(group, img, opts)
  return img
end


local lay =
{
  render = render,
  to = to,
  column = column,
  image = image,
  text = text,
  sheet = sheet
}

-- MODULE ---------------------------------------------------------------------
function lay.wrap()
  local wrap = function(fn, ...)
    wrp.fn(lay, fn, {...}, {name='lay', static=true, log=log.info})
  end

  local target = {'target', typ.tab}
  local obj    = {'object', typ.tab}
  local opts   = {'opts', typ.tab, map.tostring}

  wrap('render', target, obj, opts)
  wrap('to',     obj, {'pos', typ.tab}, opts)
  wrap('column', obj, {'space', typ.num})
  wrap('image',  target, opts)
  --wrpfn('text',   {'t', typ.tab})
  --wrpfn('sheet',  {'t', typ.tab})
end

--
function lay.test()
end

return lay