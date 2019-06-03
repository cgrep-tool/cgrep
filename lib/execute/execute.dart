import 'package:cgrep/scanner/scanner.dart';
import 'package:cgrep/parser/parser.dart';
import 'package:cgrep/ast/ast.dart';
import 'package:cgrep/eval/eval.dart';

Value _compileExpr(String cond) {
  final tokens = scan(cond);
  return parse(tokens);
}

class Evaluator {
  final Value condition;

  Evaluator(this.condition);

   factory Evaluator.compile(String condition) {
     final ifsParsed = _compileExpr(condition);
     return Evaluator(ifsParsed);
   }

  bool evaluate(Map<String, dynamic> vars) {
    return evalToBool(condition, vars);
  }
}