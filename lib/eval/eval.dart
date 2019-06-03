import 'package:cgrep/ast/ast.dart';
import 'package:cgrep/errors/errors.dart';
import 'package:cgrep/scanner/scanner.dart';

bool evalToBool(Value value, Map<String, dynamic> variables) {
  final ret = _evalValue(value, variables);
  if (ret is! bool)
    throw SyntaxError(value.span, "Expression does not evaluate to bool");
  return ret;
}

dynamic _evalValue(Value value, Map<String, dynamic> variables) {
  if (value is Column) return variables[value.name];
  if (value is SimpleValue) return value.value;
  if (value is BiExpression) return _evalBiExpression(value, variables);
  if (value is PrefixExpression) return _evalPrefixExpression(value, variables);

  throw SyntaxError(value.span, "Unsupported value");
}

dynamic _evalPrefixExpression(
    PrefixExpression value, Map<String, dynamic> variables) {
  // TODO
}

dynamic _evalBiExpression(
    BiExpression expression, Map<String, dynamic> variables) {
  final left = _evalValue(expression.left, variables);
  final right = _evalValue(expression.right, variables);

  if (expression.op.token == TokenType.cast) {
    if (right is! CGrepType) {
      throw SyntaxError(right.span, "Type expected!");
    }
    if (left == null) return null;
    switch (right.value) {
      case '@String':
        return left.toString();
      case '@Int':
        if (left is String) {
          return int.tryParse(left);
        } else if (left is num) {
          return left.toInt();
        } else if (left is DateTime) {
          return left.millisecondsSinceEpoch;
        } else if (left is Duration) {
          return left.inMilliseconds;
        } else if (left is bool) {
          return left ? 1 : 0;
        }
        throw SyntaxError(
            expression.left.span, "Unsupported conversion to Int");
      case '@Double':
        if (left is String) {
          return double.tryParse(left);
        } else if (left is num) {
          return left.toDouble();
        } else if (left is DateTime) {
          return left.millisecondsSinceEpoch.toDouble();
        } else if (left is Duration) {
          return left.inMilliseconds.toDouble();
        } else if (left is bool) {
          return left ? 1.0 : 0.0;
        }
        throw SyntaxError(
            expression.left.span, "Unsupported conversion to Double");
      case '@Date':

      case '@Bool':
        if (left is String) {
          switch(left) {
            case 't':
            case 'true':
            case 'yes':
            case 'y':
              return true;
            case 'false':
            case 'f':
            case 'n':
            case 'no':
              return false;
            default:
              throw SyntaxError(expression.left.span, "String not a valid @Bool");
          }
        } else if (left is num) {
          return left != 0;
        }
        throw SyntaxError(
            expression.left.span, "Unsupported conversion to @Bool");
      default:
        throw UnimplementedError();
    }
  }

  if (left is num && right is num) {
    switch (expression.op.token) {
      case TokenType.equal:
        return left == right;
      case TokenType.notEqual:
        return left != right;
      case TokenType.lessThan:
        return left < right;
      case TokenType.greaterThan:
        return left > right;
      case TokenType.greaterThanOrEqualTo:
        return left >= right;
      case TokenType.lessThanOrEqualTo:
        return left <= right;
      default:
        throw SyntaxError(expression.op.span, "Invalid operator");
    }
  }

  if (left is String && right is String) {
    switch (expression.op.token) {
      case TokenType.plus:
        return left + right;
      case TokenType.tilde:
        return RegExp(right).hasMatch(left);
      case TokenType.equal:
        return left == right;
      case TokenType.notEqual:
        return left != right;
      case TokenType.lessThan:
        return left.compareTo(right) < 0;
      case TokenType.greaterThan:
        return left.compareTo(right) > 0;
      case TokenType.greaterThanOrEqualTo:
        return left.compareTo(right) >= 0;
      case TokenType.lessThanOrEqualTo:
        return left.compareTo(right) <= 0;
      default:
        throw SyntaxError(expression.op.span, "Invalid operator");
    }
  }

  if (left is int && right is int) {
    switch (expression.op.token) {
      case TokenType.plus:
        return left + right;
      case TokenType.minus:
        return left - right;
      case TokenType.asterisk:
        return left * right;
      case TokenType.backwardSlash:
        return left ~/ right;
      case TokenType.percentage:
        return left % right;
      case TokenType.and:
        return left & right;
      case TokenType.or:
        return left | right;
      case TokenType.caret:
        return left ^ right;
      case TokenType.equal:
        return left == right;
      case TokenType.notEqual:
        return left != right;
      case TokenType.lessThan:
        return left < right;
      case TokenType.greaterThan:
        return left > right;
      case TokenType.greaterThanOrEqualTo:
        return left >= right;
      case TokenType.lessThanOrEqualTo:
        return left <= right;
      default:
        throw SyntaxError(expression.op.span, "Invalid operator");
    }
  }

  if (left is num && right is num) {
    switch (expression.op.token) {
      case TokenType.plus:
        return left + right;
      case TokenType.minus:
        return left - right;
      case TokenType.asterisk:
        return left * right;
      case TokenType.backwardSlash:
        return left ~/ right;
      case TokenType.percentage:
        return left % right;
      case TokenType.equal:
        return left == right;
      case TokenType.notEqual:
        return left != right;
      case TokenType.lessThan:
        return left < right;
      case TokenType.greaterThan:
        return left > right;
      case TokenType.greaterThanOrEqualTo:
        return left >= right;
      case TokenType.lessThanOrEqualTo:
        return left <= right;
      default:
        throw SyntaxError(expression.op.span, "Invalid operator");
    }
  }

  // TODO DateTime
  // TODO Duration

  if (left.runtimeType == right.runtimeType) {
    switch (expression.op.token) {
      case TokenType.equal:
        return left == right;
      case TokenType.notEqual:
        return left != right;
      default:
        throw SyntaxError(expression.op.span, "Invalid operator");
    }
  }

  throw SyntaxError(expression.span, "Operation between incompatible types");
}
