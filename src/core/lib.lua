local cfg = require "src.Config"

lib = {}

-------------------------------------------------------------------------------
-- @param obj        - display object to render
-- @param opts.group - display group insert in
-- @param vx         - optional, defaults to 0
-- @param vy         - optional, defaults to 0
function lib.render(group, obj, opts)
  assert(group)
  assert(obj)
  assert(opts)

  obj.anchorX = 0
  obj.anchorY = 0
  obj.x = cfg.vw * (opts.vx or 0);
  obj.y = cfg.vh * (opts.vy or 0);

  group:insert(obj)
end

-------------------------------------------------------------------------------
-- @param path       - path to image resource
-- @param opts.group - display group insert in
-- @param opts.vw    - width in vw
-- @param opts.ratio - width to height ratio
-- @param opts.vx    - optional, defaults to 0
-- @param opts.vy    - optional, defaults to 0
function lib.image(group, path, opts)
  assert(path)
  assert(opts)
  assert(opts.ratio)

  local width = cfg.vw * opts.vw
  local height = width / opts.ratio
  local img = display.newImageRect(path, width, height)
  
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

  local text = display.newText(opts)
  
  lib.render(group, text, opts)
end


return lib