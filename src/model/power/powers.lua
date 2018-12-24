local powers =
{
  require 'src.model.power.movediagonal',
  require 'src.model.power.multiply',
  require 'src.model.power.rehash',
  require 'src.model.power.relocate',
  require 'src.model.power.recruit',
  require 'src.model.power.swap',
  require 'src.model.power.sphere',
  require 'src.model.power.jumpproof',
  require 'src.model.power.teach',
  require 'src.model.power.learn',
  require 'src.model.power.destroy',
  require 'src.model.power.pilfer'
}

--
function powers.find(name)
  for k,v in ipairs(powers) do
    if tostring(v) == name then
      return v
    end
  end
end

return powers