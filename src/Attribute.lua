local Attribute = {}
Attribute.type = 'SpecialKey'
Attribute.kind = 'Styles'
Attribute.stage = 'self'

function Attribute:apply(value: string | { string }, applyTo: Instance)
  applyTo:SetAttribute('_TONED_ATTR', if typeof(value) == 'string' then value else table.concat(value, ','))
end

return Attribute