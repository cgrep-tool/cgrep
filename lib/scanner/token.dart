part of 'scanner.dart';

class Token {
  final TokenType type;

  final FileSpan span;

  final Match match;

  Token(this.type, this.span, this.match);

  String get text => span.text;

  @override
  String toString() {
    return '$type: "${span.text}"';
  }
}

enum TokenType {
  newLine,

  // Brackets
  leftBracket,
  rightBracket,

  plus,
  minus,
  asterisk,
  backwardSlash,
  percentage,
  and,
  or,
  tilde,
  caret,

  cast,

  equal,
  notEqual,
  lessThan,
  greaterThan,
  lessThanOrEqualTo,
  greaterThanOrEqualTo,
  like,

  logicalAnd,
  logicalOr,
  logicalNot,

  // Data
  type,
  false_,
  true_,
  integer,
  // TODO hexInteger,
  // TODO binaryInteger,
  double,
  string,
  column,
  date,
}

final normalPatterns = <Pattern, TokenType>{
  '\r\n': TokenType.newLine,
  '\n': TokenType.newLine,

  '(': TokenType.leftBracket,
  ')': TokenType.rightBracket,

  '+': TokenType.equal,
  '-': TokenType.notEqual,
  '*': TokenType.notEqual,
  '/': TokenType.lessThan,
  '%': TokenType.percentage,

  '&': TokenType.and,
  '|': TokenType.or,
  '^': TokenType.caret,
  '~': TokenType.tilde,

  '::': TokenType.cast,

  '=': TokenType.equal,
  '!=': TokenType.notEqual,
  '<>': TokenType.notEqual,
  '<': TokenType.lessThan,
  '>': TokenType.greaterThan,
  '<=': TokenType.lessThanOrEqualTo,
  '>=': TokenType.greaterThanOrEqualTo,
  '~': TokenType.like,

  '&&': TokenType.logicalAnd,
  '||': TokenType.logicalOr,
  '!': TokenType.tilde,

  'false': TokenType.false_,
  'true': TokenType.true_,
  'f': TokenType.false_,
  't': TokenType.true_,
  'no': TokenType.false_,
  'yes': TokenType.true_,
  'n': TokenType.false_,
  'y': TokenType.true_,
  RegExp(r"@[A-Z][0-9a-zA-Z_]*"): TokenType.type,
  RegExp(r'[0-9]+([_0-9]*[0-9])*'): TokenType.integer,
  // TODO RegExp(r'0x([A-Fa-f0-9]+)'): TokenType.hexInteger,
  // TODO RegExp(r'0b([01]+)'): TokenType.binaryInteger,
  RegExp(r'[0-9]+((\.[0-9]+)|b)?'): TokenType.double,
  RegExp(r"@'[0-9a-zA-Z\-\+: ]*'"): TokenType.date,
  singleQuotedString: TokenType.string,
  doubleQuotedString: TokenType.string,
  // TODO RegExp(r'[A-Za-z_][A-Za-z0-9_]*'): TokenType.identifier,
  RegExp(r'\$[0-9]+'): TokenType.column,
};

final RegExp doubleQuotedString = new RegExp(
    r'"((\\(["\\/bfnrt]|(u[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])))|([^"\\]))*"');

final RegExp singleQuotedString = new RegExp(
    r"'((\\(['\\/bfnrt]|(u[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])))|([^'\\]))*'");
