# Toned
Welcome to Toned, a module that provides a whole new way of styling your [Fusion](https://www.GitHub.com/Elttob/Fusion) UI. Tired of extremely long components filled with design fluff? With Toned you can separate functionality and design while still getting the best of both worlds.

## About Toned
Toned uses style sheets created by a custom style language allowing you to define specific styles for instances. This sounds confusing but if you've ever used HTML & CSS it's basically what CSS is to HTML.

## Quick Example

``` 
var WHITE: #FFFFFF;

.TextLabel {
  Position: [0.1, 0, 0.1, 0];
  Size: [0.3, 0, 0.3, 0];
  TextColor3: WHITE;
  TextXAlignment: enum Right;
}

.TextLabel > .UITextSizeConstraint {
  MinTextSize: 12;
  MaxTextSize: 28;
}
```

The `.TextLabel` you see is actually a selector. What this does is find all descendants that are TextLabels and apply the list of property declarations. Toned offers multiple types of selectors such as `@MyInstance` for names and `%MyAttribute` for attributes. 

In the second style statement we are selecting all UITextSizeConstraints that are direct children of TextLabels and applying some text size constraints.
If you're interested in learning more about selectors [visit the Tone Language page on the docs](https://astrealrblx.github.io/Toned/tonelang/).

## How Does It Work?
Toned uses a custom style language we call ToneLang or Tone. It comes complete with a full language pipeline including a lexer, parser, and interpreter. Each style sheet you write is parsed by Tone and the resulting output is interpreted. Toned does all the heavy lifting for you so you can focus on functionality while still designing high-quality user interfaces. If you want to learn more about internals feel free to [visit the Internals page on the docs](https://astrealrblx.github.io/Toned/internals/).