local pkg = require 'src.core.pkg'

local powers = pkg:new('src.model.power')

powers:load(
  'acidic',
  'areal',
  'counted',
  --'destroy',
  --'jumpproof',
  --'kamikadze',
  --'learn',
  --'movediagonal',
  --'multiply',
  --'parasite',
  --'parasite_host',
  --'pilfer',
  'power',
  --'recruit',
  --'rehash',
  'relocate',
  'sphere',
  'swap',
  'teach'
)

return powers