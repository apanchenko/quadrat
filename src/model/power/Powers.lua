local Powers =
{
  --require 'src.model.power.MoveDiagonal',
  --require 'src.model.power.Multiply',
  require 'src.model.power.rehash',
  require 'src.model.power.relocate',
  --require 'src.model.power.Recruit',
  --require 'src.model.power.Swap',
  --require 'src.model.power.Sphere',
  require 'src.model.power.jumpproof',
  --require 'src.model.power.Teach',
  require 'src.model.power.destroy'
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