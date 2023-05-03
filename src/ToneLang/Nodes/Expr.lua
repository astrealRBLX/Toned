local ToneLang = script.Parent.Parent

local Types = require(ToneLang.Types)

local Expr = {}

function Expr.Assignment(name: Types.Token, value: Types.ExprLiteral): Types.ExprAssignment
  local this = setmetatable({
    ID = 'Expr.Assignment',
    name = name,
    value = value,
  }, {})

  function this:accept(visitor)
    return visitor:visitAssignmentExpr(self)
  end

  return this
end

function Expr.Literal(value: any): Types.ExprLiteral
  local this = setmetatable({
    ID = 'Expr.Literal',
    value = value,
  }, {})

  function this:accept(visitor)
    return visitor:visitLiteralExpr(self)
  end

  return this
end

function Expr.Enum(value: Types.Token): Types.ExprEnum
  local this = setmetatable({
    ID = 'Expr.Enum',
    value = value,
  }, {})

  function this:accept(visitor)
    return visitor:visitEnumExpr(self)
  end

  return this
end

function Expr.Context(value: Types.Token): Types.ExprContext
  local this = setmetatable({
    ID = 'Expr.Context',
    value = value,
  }, {})

  function this:accept(visitor)
    return visitor:visitContextExpr(self)
  end

  return this
end

function Expr.Unary(op: Types.Token, right: Types.Expr): Types.ExprUnary
  local this = setmetatable({
    ID = 'Expr.Unary',
    operator = op,
    right = right,
  }, {})

  function this:accept(visitor)
    return visitor:visitUnaryExpr(self)
  end

  return this
end

return Expr