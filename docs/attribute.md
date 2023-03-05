# Attribute

Attribute is a powerful SpecialKey that ships with Toned. You can use it to easily apply certain styles to specific instances.

## Applying Attributes

```lua
New 'ScreenGui' {
  [Toned.StyleSheet] = [[
    .TextLabel {
      BackgroundColor3: #212121;
      TextColor3: #FFFFFF;
      Size: [0.8, 0, 0.1, 0];
      Position: [0.1, 0, 0.1, 0];
    }

    %RedBackground {
      BackgroundColor3: [255, 0, 0];
    }
  ]],

  [Children] = {
    New 'TextLabel' {
      Text = 'Hello World!',

      [Toned.Attribute] = 'RedBackground',
    },
  }
}
```

In the above example, we use `Attribute` on the TextLabel and set it to `RedBackground`. What this does is it sets an internal Roblox attribute on the instance which the style sheet then looks for when we being applied. We extract that attribute and determine if a selector uses it and if it does then apply the style.

An instance can have multiple attributes too. To do this you provide the `Attribute` key a table of strings instead of a single string.

```lua
New 'ScreenGui' {
  [Toned.StyleSheet] = [[
    .TextLabel {
      BackgroundColor3: #212121;
      TextColor3: #FFFFFF;
      Size: [0.8, 0, 0.1, 0];
      Position: [0.1, 0, 0.1, 0];
    }

    %RedBackground {
      BackgroundColor3: [255, 0, 0];
    }

    %BlueText {
      TextColor3: [0, 0, 255];
    }
  ]],

  [Children] = {
    New 'TextLabel' {
      Text = 'Hello World!',

      [Toned.Attribute] = {'RedBackground', 'BlueText'},
    },
  }
}
```