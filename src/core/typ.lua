local function create_typ(name)
  return setmetatable({}, {__tostring = function() return name end})
end

return
{
  any = create_typ('any'), -- not nil
  tab = create_typ('tab'),
  num = create_typ('num'),
  str = create_typ('str'),
  fun = create_typ('fun'),
  ell = create_typ('ell'), -- ellipsis
}