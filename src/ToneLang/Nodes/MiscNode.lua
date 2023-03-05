local ToneLang = script.Parent.Parent

local Types = require(ToneLang.Types)

local MiscNode = {}

function MiscNode.PropDeclaration(name: Types.Token, value: Types.ExprLiteral | Types.Variable): Types.PropDeclaration
  local this = setmetatable({
    ID = 'MiscNode.PropDeclaration',
    name = name,
    value = value,
  }, {})

  function this:accept(visitor)
    return visitor:visitPropDeclaration(self)
  end

  return this
end

function MiscNode.Variable(name: Types.Token): Types.Variable
  local this = setmetatable({
    ID = 'MiscNode.Variable',
    name = name,
  }, {})

  function this:accept(visitor)
    return visitor:visitVariable(self)
  end

  return this
end

return MiscNode