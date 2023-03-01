# Toned
Welcome to Toned, a module that provides a whole new way of styling your [Fusion](https://www.GitHub.com/Elttob/Fusion) UI. Tired of extremely long components? With Toned you can separate functionality and design while still getting the best of both worlds.

## About Toned
Toned uses style sheets created by a custom style language allowing you to define specific styles for instances. This sounds confusing but if you've ever used HTML & CSS it's basically what CSS is to HTML.

## Example
Here's a small example showcasing a single style statement.
```css
.TextLabel {
  Position: [0.1, 0, 0.1, 0];
  Size: [0.3, 0, 0.3, 0];
  TextColor3: #FFFFFF;
}
```
In Fusion this translates over to the following.
```lua
New 'TextLabel' {
  Position = UDim2.new(0.1, 0, 0.1, 0),
  Size = UDim2.new(0.3, 0, 0.3, 0),
  TextColor3 = Color3.fromHex('FFFFFF'),
}
```
This looks similar but Toned is far more powerful. The `.TextLabel` you see is actually a selector. What this does is find all descendants that are TextLabels and apply the list of property declarations. Toned offers multiple types of selectors such as `@MyInstance` for names and `%MyAttribute` for attributes. If you're interested in learning more about selectors [visit the docs](#).

## How Does It Work?
Toned uses a custom style language we call ToneLang or Tone. It comes complete with a full language pipeline including a lexer, parser, and interpreter. Each style sheet you write is parsed by Tone and the resulting output is interpreted. Toned does all the heavy lifting for you so you can focus on functionality while still designing high-quality user interfaces. If you want to learn more about internals feel free to [visit the docs](#).