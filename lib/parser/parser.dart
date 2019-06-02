import '../scanner/scanner.dart';
import '../ast/ast.dart';
import 'state.dart';
import '../errors/errors.dart';
import 'package:source_span/source_span.dart';

part 'condition.dart';

Value parse(List<Token> tokens) {
  return Parser(tokens).parse();
}

class Parser {
  State _state;

  final _errors = <SyntaxError>[];

  Iterable<SyntaxError> get errors => _errors;

  Parser(List<Token> tokens) {
    _state = State(tokens);
  }

  Value parse() {
    final ret = ExpressionParser.parse(_state);

    if(!_state.done) {
      throw Exception();
    }

    return ret;
  }
}

class ValueParser {
  static Value parse(State state) {
    final value = state.peek();

    if (value == null) {
      throw SyntaxError(
          state.last.span, "Unexpected end of file. Expression/Value expected");
    }

    if(value.type == TokenType.column) {
      state.consume();
      return Column(value.span, value.text);
    }
    if (value.type == TokenType.leftBracket) {
      return ParenthesizedExpressionParser.parse(state);
    }
    if (value.type == TokenType.integer) {
      state.consume();
      return IntValue(value.span, int.parse(value.text));
    }
    if (value.type == TokenType.double) {
      state.consume();
      return DoubleValue(value.span, double.parse(value.text));
    }
    if (value.type == TokenType.string) {
      state.consume();
      // TODO support multiple string literals
      return StringValue(
          value.span, value.text.substring(1, value.text.length - 1));
    }
    if (value.type == TokenType.true_) {
      state.consume();
      return BoolValue(value.span, true);
    }
    if (value.type == TokenType.false_) {
      state.consume();
      return BoolValue(value.span, false);
    }
    if(value.type == TokenType.not) {
      state.consume();
      final exp = ValueParser.parse(state);
      return PrefixExpression(value.span.expand(exp.span), PrefixOperator.fromToken(value), exp);
    }
    if (value.type == TokenType.date) {
      state.consume();
      return DateValue(value.span, value.text);
    }
    throw SyntaxError(value?.span, "Unknown value");
  }
}

class IntParser {
  static IntValue parse(State state) {
    final value = state.consumeIf(TokenType.integer);
    if (value == null) {
      throw SyntaxError(state.peek()?.span, "Integer expected");
    }

    return IntValue(value.span, int.parse(value.text));
  }
}
