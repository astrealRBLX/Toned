--[[

  ToneLang Grammar

  program           -> statement+ ;

  statement         -> styleStatement | exprStatement ;

  styleStatement    -> selector+ "{" propDeclaration* "}" ;
  exprStatement     -> expression ";" ;

  propDeclaration   -> IDENTIFIER ":" (unary | list | IDENTIFIER) ";" ;

  expression        -> assignment ;

  assignment        -> "var" IDENTIFIER ":" (unary | list) ;

  list              -> "[" unary ("," unary)* "]" ;
  unary             -> "-"? primary ;
  primary           -> "true" | "false" | NUMBER | STRING | hexCode | enumeration | context ;

  hexCode           -> "#" IDENTIFIER ;
  enumeration       -> "enum" IDENTIFIER ;
  context           -> "$" IDENTIFIER ("." IDENTIFIER)* ;

  selector          -> simpleSelector | ancestrySelector ;
  ancestrySelector  -> simpleSelector ">" (ancestrySelector | simpleSelector) ;
  simpleSelector    -> classSelector | traitSelector | nameSelector ;
  classSelector     -> "." IDENTIFIER ;
  nameSelector      -> "@" (IDENTIFIER | captureClause) ;
  traitSelector     -> "%" (IDENTIFIER | captureClause) ;
  captureClause     -> "(" IDENTIFIER+ ")" ;

]]