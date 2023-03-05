local ToneLang = script.Parent.Parent

local Types = require(ToneLang.Types)

local Stmt = {}

function Stmt.Expression(expr: Types.Expr): Types.StmtExpr
  local this = setmetatable({
    ID = 'Stmt.Expression',
    expression = expr,
  }, {})

  function this:accept(visitor)
    return visitor:visitExpressionStmt(self)
  end

  return this
end

function Stmt.Style(selectors: { Types.ExprSimpleSelector | Types.ExprAncestrySelector }, propDeclarations: { Types.StmtExpr }): Types.StmtStyle
  local this = setmetatable({
    ID = 'Stmt.Style',
    selectors = selectors,
    propDeclarations = propDeclarations,
  }, {})

  function this:accept(visitor)
    return visitor:visitStyleStmt(self)
  end

  return this
end

return Stmt