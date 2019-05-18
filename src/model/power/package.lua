local pkg = require 'src.lua-cor.pkg'

return pkg
:new('src.model.power')
:load(
  'power',
  'areal',
  --[[
  'acidic',
  'counted',
  'destroy',
  'invisible',
  'jumpproof',
  'kamikadze',
  'learn',
  'movediagonal',
  'multiply',
  'parasite',
  'parasite_host',
  'pilfer',
  'purify',
  'recruit',
  'rehash',
  'relocate',
  'scramble',
  'sphere',
  ]]--
  'swap',
  'teach',
  'x2'
)