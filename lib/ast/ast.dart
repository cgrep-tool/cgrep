import 'package:source_span/source_span.dart';
import '../scanner/scanner.dart';

part 'condition.dart';
part 'value.dart';

abstract class AstNode {
  FileSpan get span;

  // TODO final List<Comment> comments;

  // TODO AstNode(this.span, this.comments);

  // visitor
}

class Identifier implements AstNode {
  final FileSpan span;

  final String name;

  Identifier(this.span, this.name);
}
