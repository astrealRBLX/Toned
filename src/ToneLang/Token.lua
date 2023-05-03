local ToneLang = script.Parent

local Types = require(ToneLang.Types)

return {
  Token = function(type: string, value: any, lexeme: string, line: number): Types.Token
    return setmetatable({
      name = type,
      value = value,
      lexeme = lexeme,
      line = line,
    }, {
      __tostring = function(t)
        local str = 'Token<' .. t.name .. '>(' .. t.lexeme .. ')'

        if t.value then
          str = str .. ':' .. t.value
        end

        return str
      end
    })
  end,
  Tokens = {
    -- Literals
    IDENTIFIER        = 'ID',       -- Identifier
    NUMBER            = 'NUM',      -- 1.5
    STRING            = 'STR',      -- "Hello World!"
    HEX               = 'HEX',      -- #FFFFFF
    CONTEXT           = 'CONTEXT',  -- $Theme.Primary
    CAPTURE_CLAUSE    = 'CAPTURE',  -- (Hello World)

    -- Single-characters
    LEFT_BRACE        = 'LBRACE',
    RIGHT_BRACE       = 'RBRACE',
    LEFT_BRACKET      = 'LBRAC',
    RIGHT_BRACKET     = 'RBRAC',
    LEFT_PARENTHESES  = 'LPAREN',
    RIGHT_PARENTHESES = 'RPAREN',
    COLON             = 'COLON',
    SLASH             = 'SLASH',
    SEMICOLON         = 'SEMIC',
    COMMA             = 'COMMA',
    MINUS             = 'MINUS',
    GREATER_THAN      = 'GTHAN',
    AT                = 'AT',
    PERCENT           = 'PERC',
    DOT               = 'DOT',

    -- Keywords
    TRUE              = 'TRUE',     -- true
    FALSE             = 'FALSE',    -- false
    VAR               = 'VAR',      -- var
    ENUM              = 'ENUM',     -- enum
  }
}