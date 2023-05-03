--[[

  ToneLang Grammar

  program           -> statement+ ;

  statement         -> styleStatement | exprStatement ;

  styleStatement    -> (simpleSelector | ancestrySelector)+ "{" propDeclaration* "}" ;
  exprStatement     -> expression ";" ;

  propDeclaration   -> IDENTIFIER ":" (unary | list | IDENTIFIER) ";" ;

  expression        -> assignment ;

  assignment        -> "var" IDENTIFIER ":" (unary | list) ;

  list              -> "[" unary ("," unary)* "]" ;
  unary             -> "-"? primary ;
  primary           -> "true" | "false" | NUMBER | STRING | hexCode | enumeration | context;

  hexCode           -> "#" IDENTIFIER ;
  enumeration       -> "enum" IDENTIFIER ;
  context           -> "$" IDENTIFIER ("." IDENTIFIER)* ;

  ancestrySelector -> simpleSelector ">" (ancestrySelector | simpleSelector) ;
  simpleSelector   -> classSelector | attrSelector | nameSelector ;
  classSelector     -> "." IDENTIFIER ;
  nameSelector      -> "@" (IDENTIFIER | captureClause) ;
  attrSelector      -> "%" (IDENTIFIER | captureClause) ;
  captureClause     -> "(" IDENTIFIER+ ")" ;

]]