local Powers = {
  require 'src.view.powers.MoveDiagonal',
  require 'src.view.powers.Multiply',
  --require 'src.view.powers.Rehash',
  --require 'src.view.powers.Relocate',
  require 'src.view.powers.Recruit',
  --require 'src.view.powers.Swap',
  --require 'src.view.powers.Sphere',
  require 'src.view.powers.Impeccable',
  require 'src.view.powers.Teach',
  require 'src.view.powers.Destroy',
}

--
function Powers.Find(name)
  for k,v in ipairs(Powers) do
    if tostring(v) == name then
      return v
    end
  end
end


return Powers