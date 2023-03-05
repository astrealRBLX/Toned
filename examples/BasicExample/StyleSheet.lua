return [[
  // Here we define a variable
  var TopLeftUDim2: [0.3, 0, 0.1, 0];

  // Using the @ selector you can grab an instance by its name
  @MyFrame {
    Position: TopLeftUDim2;
    Size: [0.1, 0, 0.1, 0];
    BackgroundTransparency: 0.5;
  }

  // Using the . selector you can grab an instance by its class
  .TextLabel {
    AnchorPoint: [0.5, 0.5];      // Brackets are dynamic and translate 
    Size: [0.2, 0, 0.2, 0];       // into the proper type of what you are
    Position: [0.5, 0, 0.5, 0];   // currently trying to set
    TextScaled: true;
    TextXAlignment: enum Left;
  }

  // Use the % selector to grab an instance with a special attribute
  // Parentheses can be used to capture a multi-word selection
  %(Red Background) {
    BackgroundColor3: #FF262A; // Support for hex codes too!
  }

  %(White Text) {
    TextColor3: [255, 255, 255];
  }
]]