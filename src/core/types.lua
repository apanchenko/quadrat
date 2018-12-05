local function create_type(name)
  return setmetatable({}, {__tostring = function() return name end})
end

return
{
  any = create_type('any'), -- not nil
  tab = create_type('tab'),
  num = create_type('num'),
  str = create_type('str'),
  fun = create_type('fun'),
  ell = create_type('ell'), -- ellipsis
}