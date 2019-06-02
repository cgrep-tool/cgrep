import 'dart:io';
import 'package:cgrep/cmd.dart';

main(List<String> args) async {
  final options = Options.parse(args);
  await execute(options);
}
