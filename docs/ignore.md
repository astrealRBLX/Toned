# Ignore

With the current way Fusion handles SpecialKeys, style sheets are applied **after** the properties you specifically define for an instance. What this means is style sheets will override any properties you set. This is usually not the behavior that is expected, however, there currently is no easy workaround to this problem. As a fix, albeit not the best, Toned introduces the `Ignore` key.

## Ignoring Properties

Let's look at an example that showcases how to use the key.

```lua
New 'ScreenGui' {
  [Toned.StyleSheet] = [[
    .TextLabel {
      BackgroundColor3: #212121;
      TextColor3: #FFFFFF;
      Size: [0.8, 0, 0.1, 0];
      Position: [0.1, 0, 0.1, 0];
      Text: "Hello World!";
    }
  ]],

  [Children] = {
    New 'TextLabel' {
      Text = 'Goodbye World!',

      [Toned.Ignore] = {'Text'}
    }
  }
}
```

Notice how in our style sheet we actually set the `Text` property of TextLabels to be `Hello World!`. When we create a child text label you would expect that `Goodbye World!` would override the style sheet's `Text` property. Unfortunately, this isn't the case. To work around this we use the `Ignore` key and set it to a table of values. In our case we only want one value, `Text`. Now we'll actually see `Goodbye World!` like intended.

This is an unfortunate byproduct of Fusion's internal SpecialKey system not supporting a system like style sheets. While it can sometimes be tedious to set, the `Ignore` key is the best solution for this as of right now.