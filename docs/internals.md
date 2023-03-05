# Internals

If you're interested in learning more about how Toned works internally then this is for you.

## ToneLang

ToneLang is intricate and was designed with simplicity in mind. The original plan was to simply use string matching to create a "language" of sorts but this would be problematic and difficult to maintain. Tone needed to have longevity while being fairly easy to implement new features or extend the language. Therefore, an entire language pipeline was designed. The entirety of the language's internals can be found in `src/ToneLang`.

## Grammar

The first thought that goes into designing a language is its grammar. Tone was going to be a very small language and was not like traditional programming languages as it was intended for styling. It made sense to look towards CSS, the most popular style language. Heavy inspiration was taken from CSS in its design while still trying to maintain some semblance of a unique identity. The following is up-to-date grammar for Tone. You can also find Tone's grammar in `src/ToneLang/Grammar.lua`.

```
program           -> statement+ ;

statement         -> styleStatement | exprStatement ;

styleStatement    -> (simpleSelector | ancestrySelector)+ "{" propDeclaration* "}" ;
exprStatement     -> expression ";" ;

propDeclaration   -> IDENTIFIER ":" (unary | list | IDENTIFIER) ";" ;

expression        -> assignment ;

assignment        -> "var" IDENTIFIER ":" (unary | list) ;

list              -> "[" unary ("," unary)* "]" ;
unary             -> "-"? primary ;
primary           -> "true" | "false" | NUMBER | STRING | hexCode | enumeration ;

hexCode           -> "#" IDENTIFIER ;
enumeration       -> "enum" IDENTIFIER ;

ancestrySelector -> simpleSelector ">" (ancestrySelector | simpleSelector) ;
simpleSelector   -> classSelector | attrSelector | nameSelector ;
classSelector     -> "." IDENTIFIER ;
nameSelector      -> "@" (IDENTIFIER | captureClause) ;
attrSelector      -> "%" (IDENTIFIER | captureClause) ;
captureClause     -> "(" IDENTIFIER+ ")" ;
```

## Lexer

Tone's Lexer is very simple and like any other traditional lexer. Characters get scanned and turned into tokens as expected. The list of tokens are then passed into the parser. The lexer can be found in `src/ToneLang/Lexer.lua`.

## Parser

Tone's Parser uses Recursive Descent (RD) to parse its input tokens. There's no need for backtracking and a program (or list of statements) is created by going top down like any other RD parser. The parser can be found in `src/ToneLang/Parser.lua`.

## Interpreter

Tone's Interpreter is interesting. Tone uses methods you'll find in other language interpreters (e.g. nodes with a vistation system) but we actually can't yet interpret every node. For example, if we have a literal node that contains a list (defined as a Lua table) we have no way of knowing what type to conform that list into yet. We need to create data in the interpreter that can be read by the special `StyleSheet` key used in Fusion. To do this each interpreter instance contains the following data:

- Parse Tree 
-  Variables
- Style Sheet

The parse tree is, as expected, the tree created by our parser. We simply provide it to the interpreter and then the interpreter generates the other two crucical data points: the style sheet and variables.

Since all variables in Toned are global to their unique style sheets we don't need to worry about scope or environments. This makes it easy as whenever the interpreter reaches a variable node we simply assign a string key (the name of the variable) as a key in the variables data table where the value is the value of the variable itself.

Finally, we have the style sheet. This is the actual style sheet that is resolved by the `StyleSheet` special key in Fusion. This data point is simply a table of tables where each inner table contains an `assignments` and `selectors` table. The `assignments` table contains properties and their respective values to be set. The `selectors` table is an array of each selector token. The interpreter can be found in `src/ToneLang/Interpreter.lua`.