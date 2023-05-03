export type Token = {
  name: string,
  value: any?,
  lexeme: string,
  line: number,
}

export type Expr = {
  ID: string,
  accept: (exprSelf: any, visitor: any) -> any,
}

export type ExprAssignment = Expr & {
  name: Token,
  value: ExprLiteral,
}

export type ExprLiteral = Expr & {
  value: any,
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
  ID: string,
  accept: (stmtSelf: any, visitor: any) -> any,
}

export type StmtExpr = Stmt & {
  expression: Expr,
}

export type StmtStyle = Stmt & {
  selectors: { SelectAncestry | (SelectClass | SelectTrait | SelectName)  },
  propDeclarations: { PropDeclaration },
}

export type Select = {
  ID: string,
  accept: (selectSelf: any, visitor: any) -> any,
}

export type SelectSimple = Select & {
  value: string,
}

export type SelectClass = SelectSimple

export type SelectTrait = SelectSimple

export type SelectName = SelectSimple

export type SelectAncestry = Select & {
  parent: SelectSimple,
  child: SelectAncestry | SelectSimple
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