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
        
        -- return t.name .. ' ' .. t.lexeme .. ' ' .. if t.value then t.value else ''
      end
    })
  end,
  Tokens = {
    -- Literals
    IDENTIFIER        = 'ID',
    NUMBER            = 'NUM',
    STRING            = 'STR',
    HEX               = 'HEX',      -- #FFFFFF
    ENUM              = 'ENUM',     -- enum Center
    CONTEXT           = 'CONTEXT',  -- $Theme.Primary

    -- Selectors
    NAME_SELECT       = 'NAME',     -- @LoremIpsum or @(Lorem Ipsum)
    ATTR_SELECT       = 'ATTR',     -- %LoremIpsum or %(Lorem Ipsum)
    CLASS_SELECT      = 'CLASS',    -- .LoremIpsum

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

    -- Keywords
    TRUE              = 'TRUE',     -- true
    FALSE             = 'FALSE',    -- false
    VAR               = 'VAR',      -- var
  }
}