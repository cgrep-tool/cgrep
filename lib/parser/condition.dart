part of 'parser.dart';

const opPrecedence = <TokenType, int>{
  TokenType.lessThan: 50,
  TokenType.lessThanOrEqualTo: 50,
  TokenType.greaterThanOrEqualTo: 60,
  TokenType.greaterThan: 60,
  TokenType.equal: 70,
  TokenType.notEqual: 70,
  TokenType.like: 70,
  TokenType.logicalAnd: 100,
  TokenType.logicalOr: 100,
};

class ExpressionParser {
  static Value parse(State state) {
    return _parse(state, null);
  }

  static Value _parse(State state, Value left) {
    left ??= ValueParser.parse(state);
    Token op = state.peek();
    final int precedence = opPrecedence[op?.type];
    if (precedence == null) return left;

    while (state.peek() != null) {
      // Consume operator
      {
        op = state.peek();
        final int newPrecedence = opPrecedence[op?.type];
        if (newPrecedence == null) return left;
        state.consume();
      }
      Value right = _testNextOp(state, precedence);

      final operator = Operator.fromToken(op);
      left = BiExpression(left.span.expand(right.span), left, operator, right);
    }

    return left;
  }

  static Value _testNextOp(State state, int precedence) {
    state.consumeMany(TokenType.newLine);
    var next = ExpressionParser.parse(state);
    Token op = state.peek();
    final newPrecedence = opPrecedence[op?.type];
    if (newPrecedence == null || newPrecedence >= precedence) {
      return next;
    }
    return _parse(state, next);
  }
}

class ParenthesizedExpressionParser {
  static Value parse(State state) {
    final leftBracket = state.consumeIf(TokenType.leftBracket);
    if (leftBracket == null) {
      throw SyntaxError(
          leftBracket?.span, "Left bracket expected on expression");
    }

    final value = ExpressionParser.parse(state);

    final rightBracket = state.consumeIf(TokenType.rightBracket);
    if (rightBracket == null) {
      throw SyntaxError(
          leftBracket?.span, "Right bracket expected on end expression");
    }

    return value;
  }
}
