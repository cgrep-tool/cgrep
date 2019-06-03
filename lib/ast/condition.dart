part of 'ast.dart';

abstract class Expression implements Value {}

class PrefixExpression implements Expression {
  final FileSpan span;

  final PrefixOperator op;

  final Value value;

  PrefixExpression(this.span, this.op, this.value);

  String toString() {
    return "(${op.span.text} $value)";
  }

  @override
  String get type => "BiExpression";
}

class BiExpression implements Expression {
  final FileSpan span;

  final Value left;

  final Operator op;

  final Value right;

  BiExpression(this.span, this.left, this.op, this.right);

  String toString() {
    return "($left $op $right)";
  }

  @override
  String get type => "BiExpression";
}

class Operator implements AstNode {
  final FileSpan span;

  final TokenType token;

  Operator(this.span, this.token);

  factory Operator.fromToken(Token token) {
    return Operator(token.span, token.type);
  }

  bool get isEqual => token == TokenType.equal;

  bool get isNotEqual => token == TokenType.notEqual;

  bool get isGreaterThan => token == TokenType.greaterThan;

  bool get isLessThan => token == TokenType.lessThan;

  bool get isGreaterThanOrEqual => token == TokenType.greaterThanOrEqualTo;

  bool get isLessThanOrEqual => token == TokenType.lessThanOrEqualTo;

  bool get isAnd => token == TokenType.logicalAnd;

  bool get isOr => token == TokenType.logicalOr;

  @override
  String toString() {
    return token.toString();
  }

  /*
  static const Set<TokenType> tokens = {
    TokenType.equal,
    TokenType.notEqual,
    TokenType.greaterThan,
    TokenType.lessThan,
    TokenType.greaterThanOrEqualTo,
    TokenType.lessThanOrEqualTo,
  };
   */
}



class PrefixOperator implements AstNode {
  final FileSpan span;

  final TokenType token;

  PrefixOperator(this.span, this.token);

  factory PrefixOperator.fromToken(Token token) {
    return PrefixOperator(token.span, token.type);
  }

  bool get isNot => token == TokenType.tilde;

  @override
  String toString() {
    return token.toString();
  }

  static const Set<TokenType> tokens = {
    TokenType.tilde,
  };
}