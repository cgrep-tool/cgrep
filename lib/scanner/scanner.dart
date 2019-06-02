import 'package:string_scanner/string_scanner.dart';
import 'package:source_span/source_span.dart';

part 'token.dart';

List<Token> scan(String string, {sourceUrl}) {
  return _Scanner(string, sourceUrl: sourceUrl).scan();
}

class _Scanner {
  final List<Token> _tokens = [];

  final SpanScanner _scanner;

  static final RegExp whitespace = RegExp(r'[ \t]+');

  _Scanner(String string, {sourceUrl})
      : _scanner = SpanScanner(string, sourceUrl: sourceUrl);

  List<Token> scan() {
    while (!_scanner.isDone) {
      _scanOneToken();
    }

    return _tokens;
  }

  void _scanOneToken() {
    if (_scanner.scan(whitespace)) return;

    // Find all matching tokens
    final List<Token> tokens = normalPatterns.keys
        .map((Pattern pattern) {
          if (!_scanner.matches(pattern)) return null;

          final TokenType type = normalPatterns[pattern];

          return Token(type, _scanner.lastSpan, _scanner.lastMatch);
        })
        .where((v) => v != null)
        .toList();

    // No match?
    if (tokens.isEmpty) {
      throw Exception("Unexpected character!");
    }

    // Pick the best match (Longest)
    tokens.sort((a, b) => b.span.length.compareTo(a.span.length));
    final token = tokens.first;

    this._tokens.add(tokens.first);
    _scanner.scan(token.span.text);

    return;
  }
}
