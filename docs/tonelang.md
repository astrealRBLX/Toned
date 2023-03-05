# ToneLang

The language Toned uses is called Tone (or ToneLang). It's a custom style language created specifically for this module. It was designed to be similar to CSS so if you've ever dabbled in web design, Tone should be fairly easy to pick up.

## Comments

In your style sheet you can create comments using `--` or `//`.

```
-- This is a comment
// This is also a comment
```

!!! note
    Tone only supports single-line comments.

## Literals

Tone supports basic literals similar to Lua. The language itself is dynamically typed.

The following is a list of valid literals:

- Booleans (`true`, `false`)
- Strings (`"This is a string"`)
- Numbers (`123`)
- Hex Codes (`#FFFFFF`)
- Enums (`enum Left` -- more on enums below)
- Lists (`["This is", "my", "list"]` -- more on lists below)

## Variables

You can define variables in Tone using the `var` keyword.

```
var myVariable: 5;
```

!!! note
    Variables must be set to a literal (e.g. a string, number, hex code, etc.) Identifiers such as other variables are not valid literals and cannot be used to define a variable (e.g. `var myVariable: someOtherVariable;` is not valid).

## Selectors

When writing styles to style the various parts of your UI you need to somehow select the instances you want to style. This is where selectors come into play. Toned currently offers 3 simple selectors for instance classes, instance names, and a special attribute selector.

If you want to select an instance that has a certain class you use the `.` token.
```
.TextButton { }
```

If you want to select an instance that has a certain name you use the `@` token.
```
@MyLabel { }
```

If you want to select an instance through the special attribute selector you use the `%` token.
```
%MyAttribute { }
```

Both name and attribute selectors offer a way to select an instance that has a multi-worded name or attribute (e.g. `My Label` -- notice the space). To do so you can use a capture clause which is defined by parentheses:
```
@(My Label) { }
```

You can also combine selectors to apply a style to multiple selections.
```
.TextButton @MyLabel { } // This is completely valid
```

### Ancestry Selector

Sometimes you might only want to select an instance that has a particular ancestry. For example, a TextLabel within a Frame within another Frame called `MyFrame`. Toned allows you to do this with ease. The syntax uses the `>` token to express ancestry.

```
@MyFrame > .Frame > .TextLabel {
  Text: "Hello World!";
}
```

The style statement gets applied to the inner most element, in this case a TextLabel. Toned doesn't limit your selector capacity when using ancestry selectors. What this means is the above is considered only one single selector. You can continue using other selectors as you normally would. The syntax for having multiple selectors alongside an ancestry selector can sometimes get a little messy and therefore it is best practice to separate each selector onto its own line to maintain legibility.

```
.TextButton
@MyFrame > .Frame > .TextLabel {
  Text: "Hello World!";
}
```

The above applies the style statement to all TextButtons as well as all TextLabels within a Frame within another Frame named `MyFrame`.

## Style Statements

In the above selectors you might have noticed the curly braces following each selector. This is necessary as it tells Tone to expect a style statement. A style statement is how you style your various instances. Within the curly braces you can include various property declarations that tell Tone what value to assign a certain property of an instance.

The following is an example of a complete style statement:

```
.TextLabel {
  Text: "Hello World!"; // This line is called a property declaration
}
```

Each expression within a style statement's curly braces ending with a semicolon is considered a property declaration. On the left of the colon you write out the name of the property you are setting and on the right you define its value. You can use variables or literals as valid values. Here is a more extensive example using a variable and literals.

```
var colorWhite: #FFFFFF;

.TextLabel @(My Text Label) {
  TextColor3: colorWhite;
  Text: "This is my label!";
  Size: [0.1, 0, 0.1, 0];
}
```

## Lists

Lists are arrays of values. They are defined with an open bracket with each element inside a list being separated by a comma. Lists cannot be defined empty (e.g. `[]` is an invalid list) and at least one element must be present. The interesting thing about lists is that they are dynamic. They will conform to whatever the type of the property they are being set is. This means they can be used anywhere for values that aren't a valid literal.

```
.TextLabel {
  TextColor3: [125, 50, 180];
  Position: [0.5, 0, 0.5, 0];
  Size: [0, 30, 0, 30];
}
```

In the above example, `TextColor3` expects a Roblox `Color3` type. However, Tone doesn't support `Color3` and therefore you can just pass in a list. The same applies for the `Position` and `Size` properties. When your style sheet is applied all lists will dynamically conform to their expected type. In the case of `TextColor3`, each value in the list represents red, green, and blue in a `Color3` respectively.

!!! note
    Lists transform into `Color3` types using `Color3.fromRGB()` not `Color.new()`. Therefore each value in a list should be between 0-255.

## Enums

Similar to lists, enums will conform to their property. The following is entirely valid:

```
.TextLabel {
  TextXAlignment: enum Left;
}

.UIListLayout {
  SortOrder: enum LayoutOrder;
}
```

The property `TextXAlignment` will be set to `Enum.TextXAlignment.Left`. The property `SortOrder` will be set to `Enum.SortOrder.LayoutOrder`. Tone allows you to entirely skip writing out the enum group and get directly to the item itself.