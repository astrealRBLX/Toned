local ToneLang = script.Parent.Parent

local Types = require(ToneLang.Types)

local Select = {}

function Select.Class(value: any): Types.SelectClass
  local this = setmetatable({
    ID = 'Select.Class',
    value = value,
  }, {})

  function this:accept(visitor)
    return visitor:visitClassSelect(self)
  end

  return this
end

function Select.Name(value: any): Types.SelectName
  local this = setmetatable({
    ID = 'Select.Name',
    value = value,
  }, {})

  function this:accept(visitor)
    return visitor:visitNameSelect(self)
  end

  return this
end

function Select.Trait(value: any): Types.SelectTrait
  local this = setmetatable({
    ID = 'Select.Trait',
    value = value,
  }, {})

  function this:accept(visitor)
    return visitor:visitTraitSelect(self)
  end

  return this
end

function Select.Ancestry(parent: Types.SelectClass | Types.SelectTrait | Types.SelectName, child: Types.SelectAncestry | Types.SelectClass | Types.SelectTrait | Types.SelectName): Types.SelectAncestry
  local this = setmetatable({
    ID = 'Select.Ancestry',
    parent = parent,
    child = child,
  }, {})

  function this:accept(visitor)
    return visitor:visitAncestrySelect(self)
  end

  return this
end

return Select