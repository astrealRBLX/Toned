local Package = script.Parent

local State = require(Package.State)

local Ignore = {}
Ignore.type = 'SpecialKey'
Ignore.kind = 'Ignore'
Ignore.stage = 'self'

function Ignore:apply(value: { string }, applyTo: Instance, cleanupTasks: table)
  State.Ignoring[applyTo] = value

  table.insert(cleanupTasks, function()
    State.Ignoring[applyTo] = value
  end)
end

return Ignore
