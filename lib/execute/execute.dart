import 'package:cgrep/scanner/scanner.dart';
import 'package:cgrep/parser/parser.dart';
import 'package:cgrep/ast/ast.dart';
import 'package:cgrep/eval/eval.dart';

Value _compileExpr(String cond) {
  final tokens = scan(cond);
  return parse(tokens);
}

Evaluator compileConds(String cond, List<String> ifs) {

}

class Evaluator {
  final List<Value> ifs;

  Evaluator(this.ifs);

   factory Evaluator.compile(List<String> ifs) {
     final ifsParsed = ifs.map(_compileExpr).toList();
     return Evaluator(ifsParsed);
   }

  bool evaluate(Map<String, dynamic> vars) {
    if(ifs.any((e) => !evalToBool(e, vars))) return false;

    return true;
  }
}