local Lexer = {}
local LexerClass = {}

local ToneLang = script.Parent

local Types = require(ToneLang.Types)
local TokenModule = require(ToneLang.Token)

local Tokens = TokenModule.Tokens
local Token = TokenModule.Token

local Keywords = {
  ['true'] = Tokens.TRUE,
  ['false'] = Tokens.FALSE,
  ['var'] = Tokens.VAR,
  ['enum'] = Tokens.ENUM,
}

local WHITESPACE = {'', ' ', '\n', '\t', '\r', '\v', '\f'}
local function isWhitespace(char: string)
  return if table.find(WHITESPACE, char) then true else false
end

local function isAlpha(char: string)
  return not string.match(char, '%W') or char == '_'
end

local function isDigit(char: string)
  return not string.match(char, '%D')
end

local function isAlphaNum(char: string)
  return isAlpha(char) or isDigit(char)
end

local function isHexCode(char: string)
  return string.match(char, '%x')
end

function Lexer.new(input: string)
  return setmetatable({
    position = 0,
    start = 0,
    line = 1,
    character = '',
    source = input,
    tokens = {} :: { Types.Token },
  }, {
    __index = LexerClass,
  })
end

function LexerClass:Scan()
  while not self:IsFinished() do
    self.start = self.position + 1
    self:ScanToken()
  end

  return self.tokens
end

function LexerClass:ScanToken()
  local char = self:Next()

  if isWhitespace(char) then
    if char == '\n' then
      self.line += 1
    end
  elseif char == '{' then
    self:AddToken(Tokens.LEFT_BRACE)
  elseif char == '}' then
    self:AddToken(Tokens.RIGHT_BRACE)
  elseif char == ':' then
    self:AddToken(Tokens.COLON)
  elseif char == ';' then
    self:AddToken(Tokens.SEMICOLON)
  elseif char == '%' then
    if self:Peek() == '(' then
      self:Next()
      self:ResolveAttributeSelection(true)
    else
      self:ResolveAttributeSelection()
    end
  elseif char == '@' then
    if self:Peek() == '(' then
      self:Next()
      self:ResolveNameSelection(true)
    else
      self:ResolveNameSelection()
    end
  elseif char == '.' then
    self:ResolveClassSelection()
  elseif char == '/' then
    if self:Match('/') then
      while self:Peek() ~= '\n' and not self:IsFinished() do
        self:Next()
      end
    else
      self:AddToken(Tokens.SLASH)
    end
  elseif char == '-' then
    if self:Match('-') then
      while self:Peek() ~= '\n' and not self:IsFinished() do
        self:Next()
      end
    else
      self:AddToken(Tokens.MINUS)
    end
  elseif char == '[' then
    self:AddToken(Tokens.LEFT_BRACKET)
  elseif char == ']' then
    self:AddToken(Tokens.RIGHT_BRACKET)
  elseif char == ',' then
    self:AddToken(Tokens.COMMA)
  elseif char == '>' then
    self:AddToken(Tokens.GREATER_THAN)
  elseif char == '$' then
    self:ResolveContext()
  elseif char == '#' then
    self:ResolveHexCode()
  elseif char == '"' then
    self:ResolveString()
  elseif isDigit(char) then
    self:ResolveNumber()
  elseif isAlpha(char) then
    self:ResolveIdentifier()
  else
    warn('Unexpected character at line', self.line)
  end
end

function LexerClass:IsFinished()
  return self.position >= string.len(self.source)
end

function LexerClass:Peek()
  return if self:IsFinished() then '\0' else string.sub(self.source, self.position + 1, self.position + 1)
end

function LexerClass:PeekNext()
  return if self:IsFinished() then '\0' else string.sub(self.source, self.position + 2, self.position + 2)
end

function LexerClass:Match(expected: string)
  if self:IsFinished() or self:Peek() ~= expected then
    return false
  end

  self.position += 1

  return true
end

function LexerClass:AddToken(tokenName: string, value: any?)
  table.insert(self.tokens, Token(tokenName, value, string.sub(self.source, self.start, self.position), self.line))
end

function LexerClass:Next()
  self.position += 1
  self.character = string.sub(self.source, self.position, self.position)
  return self.character
end

function LexerClass:ResolveAttributeSelection(multiSelect: boolean?)
  multiSelect = multiSelect or false

  if multiSelect then
    while self:Peek() ~= ')' and not self:IsFinished() do
      if self:Peek() == '\n' then
        self.line += 1
      end

      self:Next()
    end
  else
    while isAlphaNum(self:Peek()) do
      self:Next()
    end
  end

  if multiSelect and self:IsFinished() then
    warn('Unterminated instance attribute selection.')
    return
  end

  if multiSelect then
    self:Next()
  end

  self:AddToken(Tokens.ATTR_SELECT,
    string.sub(
      self.source,
      if multiSelect then self.start + 2 else self.start + 1,
      if multiSelect then self.position - 1 else self.position
    )
  )
end

function LexerClass:ResolveNameSelection(multiSelect: boolean?)
  multiSelect = multiSelect or false

  if multiSelect then
    while self:Peek() ~= ')' and not self:IsFinished() do
      if self:Peek() == '\n' then
        self.line += 1
      end

      self:Next()
    end
  else
    while isAlphaNum(self:Peek()) do
      self:Next()
    end
  end

  if multiSelect and self:IsFinished() then
    warn('Unterminated instance name selection.')
    return
  end

  if multiSelect then
    self:Next()
  end

  self:AddToken(Tokens.NAME_SELECT,
    string.sub(
      self.source,
      if multiSelect then self.start + 2 else self.start + 1,
      if multiSelect then self.position - 1 else self.position
    )
  )
end

function LexerClass:ResolveClassSelection()
  while isAlphaNum(self:Peek()) do
    self:Next()
  end

  self:AddToken(Tokens.CLASS_SELECT,
    string.sub(
      self.source,
      self.start + 1,
      self.position
    )
  )
end

function LexerClass:ResolveContext()
  local contextString = ''
  local contextStart = self.start + 1

  while isAlpha(self:Peek()) or self:Peek() == '.' do
    self:Next()

    if self:Match('.') then
      contextString = contextString .. string.sub(self.source, contextStart, self.position)
      contextStart = self.position + 1
    end
  end

  contextString = contextString .. string.sub(self.source, contextStart, self.position)

  self:AddToken(
    Tokens.CONTEXT,
    contextString
  )
end

function LexerClass:ResolveHexCode()
  while isHexCode(self:Peek()) do
    self:Next()
  end

  if self.position - self.start ~= 6 then
    warn('Invalid Hex Color Code.')
  end

  self:AddToken(
    Tokens.HEX,
    Color3.fromHex(
      string.sub(self.source, self.start + 1, self.position)
    )
  )
end

function LexerClass:ResolveNumber()
  while isDigit(self:Peek()) do
    self:Next()
  end

  if self:Peek() == '.' and isDigit(self:PeekNext()) then
    self:Next()

    while isDigit(self:Peek()) do
      self:Next()
    end
  end

  self:AddToken(Tokens.NUMBER, tonumber(string.sub(self.source, self.start, self.position)))
end

function LexerClass:ResolveString()
  while self:Peek() ~= '"' and not self:IsFinished() do
    if self:Peek() == '\n' then
      self.line += 1
    end

    self:Next()
  end

  if self:IsFinished() then
    warn('Unterminated string.')
    return
  end

  self:Next()
  self:AddToken(Tokens.STRING, string.sub(self.source, self.start + 1, self.position - 1))
end

function LexerClass:ResolveIdentifier()
  while isAlphaNum(self:Peek()) do
    self:Next()
  end

  local text = string.sub(self.source, self.start, self.position)
  local token = Keywords[text]

  if token == nil then
    token = Tokens.IDENTIFIER
  end

  -- Handle enum
  if #self.tokens > 1 and self.tokens[#self.tokens].name == Tokens.ENUM then
    self.tokens[#self.tokens].value = text
    return
  end

  self:AddToken(token)
end

return Lexer