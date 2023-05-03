local Trait = {}
Trait.type = 'SpecialKey'
Trait.kind = 'Styles'
Trait.stage = 'self'

function Trait:apply(value: string | { string }, applyTo: Instance)
  applyTo:SetAttribute('_TONED_TRAIT', if typeof(value) == 'string' then value else table.concat(value, ','))
end

return Trait