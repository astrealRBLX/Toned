local Package = script.Parent

local ToneLang = Package.ToneLang
local ToneLangTypes = require(ToneLang.Types)

local State = {}

type IgnoreData = { string }

State.StyleSheets = {} :: { ToneLangTypes.StyleSheet }
State.Ignoring = {} :: { [Instance]: IgnoreData }

return State