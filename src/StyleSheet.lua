local Package = script.Parent

local State = require(Package.State)

local ToneLang = Package.ToneLang
local Lexer = require(ToneLang.Lexer)
local Parser = require(ToneLang.Parser)
local Interpreter = require(ToneLang.Interpreter)
local Tokens = require(ToneLang.Token).Tokens
local ToneLangTypes = require(ToneLang.Types)

local StyleSheet = {}
StyleSheet.type = 'SpecialKey'
StyleSheet.kind = 'StyleSheet'
StyleSheet.stage = 'observer'

local function validateListSize(list: { any }, size: number)
  if  #list < size then
    error('Invalid list size.')
  end
end

local function resolveListType(propType: string, list: { any })
  if propType == 'Color3' then
    validateListSize(list, 3)

    return Color3.fromRGB(list[1], list[2], list[3])
  elseif propType == 'UDim2' then
    validateListSize(list, 4)

    return UDim2.new(list[1], list[2], list[3], list[4])
  elseif propType == 'UDim' then
    validateListSize(list, 2)

    return UDim.new(list[1], list[2])
  elseif propType == 'Vector2' then
    validateListSize(list, 2)

    return Vector2.new(list[1], list[2])
  end
end

local function resolveEnumType(property: string, enumValue: ToneLangTypes.Token)
  return Enum[property][enumValue.value]
end

local function resolveContext(contextToken: ToneLangTypes.Token, context: table?)
  if context == nil then
    error('No context was supplied to the style sheet.')
  end

  local ctxTable = string.split(contextToken.value, '.')
  local value = context

  local index = 1
  while type(value) == 'table' do
    value = value[ctxTable[index]]

    index += 1
  end

  return value
end

local function resolveTraitValues(attr: string)
  return string.split(attr, ',')
end

local function applyAssignments(assignments: { [string]: any }, descendant: Instance, context: table?)
  for property, propValue in assignments do
    local propertyExists, propertyValue = pcall(function()
      return descendant[property]
    end)

    if not propertyExists then
      error('Property \'' .. property .. '\' does not exist on \'' .. descendant.ClassName .. '\'.')
    end

    if State.Ignoring[descendant] and table.find(State.Ignoring[descendant], property) then
      continue
    end

    -- Value is a list; must resolve into Roblox type
    if typeof(propValue) == 'table' and propValue.name == nil then
      propValue = resolveListType(typeof(propertyValue), propValue)
    -- Value is an enum; must resolve into Roblox enum
    elseif typeof(propValue) == 'table' and propValue.name == Tokens.ENUM then
      propValue = resolveEnumType(property, propValue)
    -- Value is context; must locate proper value
    elseif typeof(propValue) == 'table' and propValue.name == Tokens.CONTEXT then
      propValue = resolveContext(propValue, context)
    end

    if typeof(propValue) ~= typeof(propertyValue) then
      error('Property mismatch!')
    else
      descendant[property] = propValue
    end
  end
end

local function validateSimpleSelector(selectorToken: ToneLangTypes.Token, descendant: Instance)
  if (selectorToken.name == Tokens.NAME_SELECT and descendant.Name == selectorToken.value) or (selectorToken.name == Tokens.CLASS_SELECT and descendant.ClassName == selectorToken.value) then
    return true
  elseif selectorToken.name == Tokens.ATTR_SELECT then
    local attr = descendant:GetAttribute('_TONED_TRAIT')

    if attr and table.find(resolveTraitValues(attr), selectorToken.value) then
      return true
    end
  end

  return false
end

local function validateAncestrySelector(activeTable: table, current: Instance)
  -- {[1] = PARENT, [2] = CHILD}

  local parentToken: ToneLangTypes.Token = activeTable[1]
  local childTable = activeTable[2]

  if not validateSimpleSelector(parentToken, current) then
    return
  end

  for _, child in current:GetChildren() do
    if childTable.name then
      if validateSimpleSelector(childTable, child) then
        return child
      end
    else
      return validateAncestrySelector(childTable, child)
    end
  end
end

local function validateSelectorTokens(selectorTokens: { ToneLangTypes.Token }, descendant: Instance, applyCallback: (toAssign: Instance) -> ())
  for _, selectorToken: ToneLangTypes.Token in selectorTokens do
    -- Ancestry selector
    if selectorToken.name == nil and #descendant:GetChildren() > 0 then
      local toAssign = validateAncestrySelector(selectorToken, descendant)

      if toAssign then
        applyCallback(toAssign)
      end

      continue
    end

    -- Simple selector
    if validateSimpleSelector(selectorToken, descendant) then
      applyCallback(descendant)
    end
  end
end

function StyleSheet:apply(value: string, applyTo: Instance, cleanupTasks: table)
  local lexer = Lexer.new(value)
  local tokens = lexer:Scan()

  local parser = Parser.new(tokens)
  local tree = parser:Parse()

  local interpreter = Interpreter.new(tree)
  interpreter:Interpret()

  table.insert(State.StyleSheets, interpreter.styleSheet)

  local styleSheetIndex = #State.StyleSheets

  for _, style in interpreter.styleSheet do
    for _, desc in applyTo:GetDescendants() do
      validateSelectorTokens(style.selectors, desc, function(toAssign: Instance)
        applyAssignments(style.assignments, toAssign, self.context)
      end)
    end
  end

  local descendantAddedConn = applyTo.DescendantAdded:Connect(function()
    for _, style in interpreter.styleSheet do
      for _, desc in applyTo:GetDescendants() do
        validateSelectorTokens(style.selectors, desc, function(toAssign: Instance)
          applyAssignments(style.assignments, toAssign, self.context)
        end)
      end
    end
  end)

  table.insert(cleanupTasks, descendantAddedConn)
  table.insert(cleanupTasks, function()
    table.remove(State.StyleSheets, styleSheetIndex)
  end)
end

return setmetatable({}, {
  __index = StyleSheet,
  __call = function(_, context: table)
    return setmetatable({
      context = context,
    }, {
      __index = StyleSheet
    })
  end
})