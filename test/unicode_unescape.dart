import 'package:cgrep/utils/string_unescape.dart';
import 'package:test/test.dart';

void main() {
  group("unicode_unescape", () {
    test('calculate', () {
      expect(unescape(r"abcΩ\t123ΩΩΩ\n\"), "abcΩ\t123ΩΩΩ\n");
      expect(unescape(r"abcΩ\\abcΩ\\\\ΩΩ\\"), "abcΩ\\abcΩ\\\\ΩΩ\\");

      expect(unescape(r"a\zc"), "azc");

      expect(unescape(r"a\x0ab"), "a\nb");
      expect(unescape(r"a\u03a9b"), "aΩb");
      expect(unescape(r"a\u{1F000}b"), "a🀀b");
    });
  });
}
