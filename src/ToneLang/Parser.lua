local Parser = {}
local ParserClass = {}

local ToneLang = script.Parent

local Types = require(ToneLang.Types)
local Tokens = require(ToneLang.Token).Tokens
local Expr = require(ToneLang.Nodes.Expr)
local Stmt = require(ToneLang.Nodes.Stmt)
local MiscNode = require(ToneLang.Nodes.MiscNode)

function Parser.new(tokens: { Types.Token })
  return setmetatable({
    position = 1,
    tokens = tokens,
  }, {
    __index = ParserClass
  })
end

function ParserClass:Parse()
  local statements: { Types.Stmt } = {}

  while not self:IsFinished() do
    table.insert(statements, self:Statement())
  end

  return statements
end

function ParserClass:Statement()
  if self:Match(Tokens.CLASS_SELECT, Tokens.ATTR_SELECT, Tokens.NAME_SELECT) then
    return self:StyleStatement()
  end

  return self:ExpressionStatement()
end

function ParserClass:StyleStatement()
  local selectors: { Types.ExprAncestrySelector | Types.ExprSimpleSelector } = {
    -- Expr.Selector(self:Previous()),
    self:Selector(),
  }

  while self:Match(Tokens.CLASS_SELECT, Tokens.ATTR_SELECT, Tokens.NAME_SELECT) do
    table.insert(selectors, self:Selector())
  end

  self:Consume(Tokens.LEFT_BRACE, 'Expected \'{\' after style selector(s) to begin style statement.')

  local statements: { Types.StmtExpr } = {}

  while not self:Check(Tokens.RIGHT_BRACE) and not self:IsFinished() do
    table.insert(statements, self:PropDeclaration())
  end

  self:Consume(Tokens.RIGHT_BRACE, 'Expected \'}\' to close style statement.')

  return Stmt.Style(selectors, statements)
end

function ParserClass:ExpressionStatement()
  local expr = self:Expression()

  self:Consume(Tokens.SEMICOLON, 'Expected \';\' after expression.')

  return Stmt.Expression(expr)
end

function ParserClass:PropDeclaration()
  if self:Match(Tokens.IDENTIFIER) and self:Check(Tokens.COLON) then
    local identifier = self:Previous()

    self:Consume(Tokens.COLON, 'Expected \':\' after identifier in property declaration.')

    local val: Types.ExprLiteral | Types.Variable

    if self:Check(Tokens.LEFT_BRACKET) then
      val = self:List()
    elseif self:Check(Tokens.IDENTIFIER) then
      val = MiscNode.Variable(self:Next())
    else
      val = self:Unary()
    end

    self:Consume(Tokens.SEMICOLON, 'Expected \';\' after primary value in property declaration.')

    return MiscNode.PropDeclaration(identifier, val)
  end
end

function ParserClass:Selector()
  if self:Check(Tokens.GREATER_THAN) then
    return self:AncestrySelector()
  end

  return self:SimpleSelector()
end

function ParserClass:SimpleSelector()
  return Expr.SimpleSelector(self:Previous())
end

function ParserClass:AncestrySelector()
  local parentExpr = Expr.SimpleSelector(self:Previous())

  self:Consume(Tokens.GREATER_THAN, 'Expected \'>\' between selectors for ancestry selection.')

  local childExpr = Expr.SimpleSelector(self:Next())

  if self:Check(Tokens.GREATER_THAN) then
    childExpr = self:AncestrySelector()
  end

  return Expr.AncestrySelector(parentExpr, childExpr)
end

function ParserClass:Expression()
  return self:Assignment()
end

function ParserClass:Assignment()
  if self:Match(Tokens.VAR) and self:Check(Tokens.IDENTIFIER) then
    local identifier = self:Next()

    self:Consume(Tokens.COLON, 'Expected \':\' after identifier in variable assignment.')

    local val = if self:Check(Tokens.LEFT_BRACKET) then self:List() else self:Unary()

    return Expr.Assignment(identifier, val)
  end
end

function ParserClass:List()
  self:Consume(Tokens.LEFT_BRACKET, 'Expected \'[\' to initialize list.')

  local listValues = {
    self:Unary().value,
  }

  while not self:Check(Tokens.RIGHT_BRACKET) do
    if self:Check(Tokens.COMMA) then
      self:Consume(Tokens.COMMA, 'Expected \',\' to continue list.')

      table.insert(listValues, self:Unary().value)
    else
      break
    end
  end

  self:Consume(Tokens.RIGHT_BRACKET, 'Expected \']\' to finalize list.')

  return Expr.Literal(listValues)
end

function ParserClass:Unary()
  if self:Match(Tokens.MINUS) then
    local op = self:Previous()
    local right = self:Primary()

    return Expr.Unary(op, right)
  end

  return self:Primary()
end

function ParserClass:Primary()
  if self:Match(Tokens.FALSE) then return Expr.Literal(false) end
  if self:Match(Tokens.TRUE) then return Expr.Literal(true) end

  if self:Match(Tokens.NUMBER, Tokens.STRING, Tokens.HEX) then
    return Expr.Literal(self:Previous().value)
  end

  if self:Match(Tokens.ENUM) then
    return Expr.Enum(self:Previous())
  end
end

function ParserClass:Consume(tokenName: string, message: string)
  if self:Check(tokenName) then
    return self:Next()
  end

  error(message)
end

function ParserClass:IsFinished(): boolean
  return self.position > #self.tokens
end

function ParserClass:Match(...: string): boolean
  for _, tokenName in {...} do
    if self:Check(tokenName) then
      self:Next()
      return true
    end
  end

  return false
end

function ParserClass:Current(): Types.Token
  return self.tokens[self.position]
end

function ParserClass:Check(tokenName: string): boolean
  if self:IsFinished() then
    return false
  end

  return self:Current().name == tokenName
end

function ParserClass:Previous(): Types.Token
  return self.tokens[self.position - 1]
end

function ParserClass:Next()
  if not self:IsFinished() then
    self.position += 1
  end

  return self:Previous()
end

return Parser