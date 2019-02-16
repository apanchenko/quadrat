local pkg = require 'src.core.pkg'

local powers = pkg:new('src.model.power')

powers:load(
  'power',
  'areal',
  'counted',
  'movediagonal',
  'multiply',
  'rehash',
  'relocate',
  'recruit',
  'swap',
  'sphere',
  'jumpproof',
  'teach',
  'learn',
  'destroy',
  'parasite',
  'parasite_host',
  'pilfer'
)

return powers