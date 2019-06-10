import 'package:cgrep/scanner/scanner.dart';
import 'package:test/test.dart';

void main() {
  group('TokenRegex', () {
    test('String', () {
      expect(RegExes.string.stringMatch('"Hello world!"'),
          r'"Hello world!"');
      expect(RegExes.string.stringMatch(r'"Hello \"world\"!"'),
          r'"Hello \"world\"!"');
      expect(RegExes.string.stringMatch(r'"sdf\x08df"'),
          r'"sdf\x08df"');

      expect(RegExes.string.stringMatch(r'"Hello \" world"!"'),
          r'"Hello \" world"');

      expect(RegExes.string.stringMatch(r'"\\\"\\"'), r'"\\\"\\"');
    });
  });
}
