# Style Sheets

Style sheets are the main part of Toned. They allow you to define styles to apply to your UI.

Let's create a basic style sheet.

## Creating Style Sheets

In reality, style sheets are just strings. Really, really, long strings. Unfortunately, Roblox doesn't support other file types besides .lua (which always translate into Script instances). This means to use a custom styling language we just use a string. It is best practice to have your style sheet be its own ModuleScript. Here's how one might look:

```lua
return [[

  // This is a style sheet!

]]
```

!!! note
    In the rest of the documentation we won't include the return statement or the open & closing brackets for the string. Assume they are there anyways.

To learn the language used by style sheets visit [the language documentation](tonelang.md).

## Applying Style Sheets

Toned comes equipped with a special key you can use in Fusion to apply your style sheets.

```lua

local Toned = require(ReplicatedStorage.Toned)

New 'ScreenGui' {
  [Toned.StyleSheet] = require(script.Parent.SomeStyleSheet)
}

```

Style sheets are applied to all descendants of the instance they are applied to. If a descendant is added to the root instance then the style sheet after it has initially been applied then it will also apply itself to that new descendant. Here is a better example of this:

```lua
local myLabels = Value({'Hello!'})

New 'ScreenGui' {
  [Toned.StyleSheet] = [[
    .TextLabel {
      BackgroundColor3: #212121;
      TextColor3: #FFFFFF;
      TextXAlignment: enum Center;
      Size: [0.05, 0, 0.05, 0];
    }
  ]],

  [Children] = ForPairs(myLabels, function(key: number, value: string)
    return key, New 'TextLabel' {
      Text = value,
      Position = UDim2.new(key * 0.05, 0, 0.05, 0),
    }
  end, Fusion.cleanup)
}

task.wait(5)

myLabels:set({'These', 'labels', 'are', 'styled!'})
```

When the `myLabels` value changes the new labels created all have their respective styles applied from the style sheet.