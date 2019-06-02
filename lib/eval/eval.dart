import 'package:cgrep/ast/ast.dart';
import 'package:cgrep/errors/errors.dart';
import 'package:cgrep/scanner/scanner.dart';

bool evalToBool(Value value, Map<String, dynamic> variables) {
  final ret = _evalValue(value, variables);
  if(ret is! bool) throw SyntaxError(value.span, "Expression does not evaluate to bool");
  return ret;
}

dynamic _evalValue(Value value, Map<String, dynamic> variables) {
  if(value is Column) return variables[value.name];
  if(value is SimpleValue) return value.value;
  if(value is BiExpression) return _evalBiExpression(value, variables);
  if(value is PrefixExpression) return _evalPrefixExpression(value, variables);

  throw SyntaxError(value.span, "Unsupported value");
}

dynamic _evalPrefixExpression(PrefixExpression value, Map<String, dynamic> variables) {
  // TODO
}

dynamic _evalBiExpression(BiExpression expression, Map<String, dynamic> variables) {
  final left = _evalValue(expression.left, variables);
  final right = _evalValue(expression.right, variables);

  if(left.runtimeType == right.runtimeType) {
    switch(expression.op.token) {
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