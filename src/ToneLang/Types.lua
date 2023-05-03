export type Token = {
  name: string,
  value: any?,
  lexeme: string,
  line: number,
}

export type Expr = {
  accept: (exprSelf: any, visitor: any) -> any,
}

export type ExprAssignment = Expr & {
  name: Token,
  value: ExprLiteral,
}

export type ExprLiteral = Expr & {
  value: any,
}

export type ExprSimpleSelector = Expr & {
  value: Token,
}

export type ExprAncestrySelector = Expr & {
  parent: ExprSimpleSelector,
  child: ExprAncestrySelector | ExprSimpleSelector,
}

export type ExprUnary = Expr & {
  operator: Token,
  right: Expr,
}

export type ExprEnum = Expr & {
  value: Token,
}

export type ExprContext = Expr & {
  value: Token,
}

export type Stmt = {
  accept: (stmtSelf: any, visitor: any) -> any,
}

export type StmtExpr = Stmt & {
  expression: Expr,
}

export type StmtStyle = Stmt & {
  selectors: { ExprAncestrySelector | ExprSimpleSelector  },
  propDeclarations: { PropDeclaration },
}

export type PropDeclaration = Expr & {
  name: Token,
  value: ExprLiteral | Variable,
}

export type Variable = Expr & {
  name: Token,
}

export type StyleSheet = {
  assignments: { [string]: any },
  selectors: { Token | table }
}

return nil