local cfg = require "src.Config"

lib = {}

--[[-----------------------------------------------------------------------------
group   display group insert in
obj     display object to render
opts:
  vx    defaults to 0
  vy    defaults to 0
-----------------------------------------------------------------------------]]--
function lib.render(group, obj, opts)
  assert(group, "group is nil")
  assert(obj, "object is nil")
  assert(opts)

  obj.anchorX = 0
  obj.anchorY = 0
  obj.x = cfg.vw * (opts.vx or 0);
  obj.y = cfg.vh * (opts.vy or 0);

  group:insert(obj)
end

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
function lib.image(group, path, opts)
  assert(path)
  assert(opts)

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
  
  lib.render(group, img, opts)

  return img
end

-------------------------------------------------------------------------------
-- @param group      - display group insert in
-- @param opts.text  - text to render
-- @param opts.vx    - optional, defaults to 0
-- @param opts.vy    - optional, defaults to 0
function lib.text(group, opts)
  assert(opts)

  if opts.font == nil then
    opts.font = cfg.font                    -- select default font
  end

  if opts.w then
    opts.width = opts.w
  elseif opts.vw then
    opts.width = opts.vw * cfg.vw
  end

  local text = display.newText(opts)
  
  lib.render(group, text, opts)

  return text
end


return lib