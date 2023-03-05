local Interpreter = {}
local InterpreterClass = {}

local ToneLang = script.Parent

local Types = require(ToneLang.Types)
local Tokens = require(ToneLang.Token).Tokens

function Interpreter.new(tree: { Types.Stmt })
  return setmetatable({
    tree = tree,
    styleSheet = {} :: Types.StyleSheet,
    variables = {} :: { [string]: any },
  }, {
    __index = InterpreterClass,
  })
end

function InterpreterClass:Interpret()
  for _, statement in self.tree do
    self:Evaluate(statement)
  end
end

function InterpreterClass:Evaluate(toEval: Types.Stmt | Types.Expr | Types.PropDeclaration)
  return toEval:accept(self)
end

function InterpreterClass:visitExpressionStmt(stmt: Types.StmtExpr)
  self:Evaluate(stmt.expression)
end

function InterpreterClass:visitStyleStmt(stmt: Types.StmtStyle)
  local selectors: { Types.Token | table } = {}

  for _, selector in stmt.selectors do
    table.insert(selectors, self:Evaluate(selector))
  end

  local assignments: { Types.Token } = {}

  for _, propDecl in stmt.propDeclarations do
    local name: Types.Token, value: any = self:Evaluate(propDecl)
    assignments[name.lexeme] = value
  end

  table.insert(self.styleSheet, {
    selectors = selectors,
    assignments = assignments,
  })
end

function InterpreterClass:visitPropDeclaration(decl: Types.PropDeclaration)
  return decl.name, self:Evaluate(decl.value)
end

function InterpreterClass:visitLiteralExpr(expr: Types.ExprLiteral)
  return expr.value
end

function InterpreterClass:visitEnumExpr(expr: Types.ExprEnum)
  return expr.value
end

function InterpreterClass:visitVariable(expr: Types.Variable)
  return self.variables[expr.name.lexeme]
end

function InterpreterClass:visitUnaryExpr(expr: Types.ExprUnary)
  local right = self:Evaluate(expr.right)

  if expr.operator.name == Tokens.MINUS then
    return -right
  end
end

function InterpreterClass:visitAssignmentExpr(expr: Types.ExprAssignment)
  self.variables[expr.name.lexeme] = self:Evaluate(expr.value)
end

function InterpreterClass:visitSimpleSelectorExpr(expr: Types.ExprSimpleSelector)
  return expr.value
end

function InterpreterClass:visitAncestrySelectorExpr(expr: Types.ExprAncestrySelector)
  local parent: Types.Token = self:Evaluate(expr.parent)
  local child: Types.Token = self:Evaluate(expr.child)

  return {parent, child}
end

return Interpreter