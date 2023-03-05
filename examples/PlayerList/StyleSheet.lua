return [[
  var BACKGROUND: #212121;
  var INNER_BACKGROUND: #121212;
  var WHITE: #FFFFFF;
  var RED: #FF173E;

  var PADDING: [0, 8];
  var PADDING_SMALL: [0, 2];

  @PlayerContainer {
    AnchorPoint: [1, 0];
    Position: [0.95, 0, 0.05, 0];
    Size: [0.2, 0, 0.35, 0];
    BackgroundColor3: BACKGROUND;
  }

  .TextLabel .TextButton {
    Size: [1, 0, 0, 22];
    TextScaled: true;
    TextColor3: WHITE;
    RichText: true;
    Font: enum Nunito;
  }

  .TextButton {
    Size: [0, 22, 0, 22];
    Position: [0.9, 0, 0.5, 0];
    AnchorPoint: [0.5, 0.5];
    BackgroundColor3: INNER_BACKGROUND;
    TextColor3: RED;
  }

  %PlayerListTitle {
    Size: [1, 0, 0, 24];
    Text: "<b><u>Player List</u></b>";
    BackgroundTransparency: 1;
  }

  %PlayerLabel {
    TextXAlignment: enum Left;
    BackgroundColor3: INNER_BACKGROUND;
  }

  .UICorner {
    CornerRadius: [0, 14];
  }

  .UIListLayout {
    SortOrder: enum Name;
    FillDirection: enum Vertical;
    Padding: PADDING;
  }

  .UIPadding {
    PaddingTop: PADDING;
    PaddingBottom: PADDING;
    PaddingLeft: PADDING;
    PaddingRight: PADDING;
  }

  %SmallPadding {
    PaddingTop: PADDING_SMALL;
    PaddingBottom: PADDING_SMALL;
    PaddingLeft: PADDING;
    PaddingRight: PADDING;
  }

  %LargeRadius {
    CornerRadius: [1, 0];
  }
]]