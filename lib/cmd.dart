import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

import 'package:cgrep/execute/execute.dart';

class Options {
  final String condition;

  final List<String> lets;

  final String delimiter;

  final String input;

  Options(this.input, this.delimiter, this.condition, this.lets);

  factory Options.parse(List<String> args) {
    final parser = ArgParser()
      ..addMultiOption('let', abbr: 'l')
      ..addOption('delimiter', abbr: 'd', defaultsTo: ',');

    final result = parser.parse(args);

    if (result.rest.isEmpty) {
      stderr.writeln("Grep condition missing!\r\n" + parser.usage);
    }

    if (result.rest.length > 2) {
      stderr.writeln(
          "Multiple input files not supported yet: ${result.rest.skip(1)}!\r\n" +
              parser.usage);
      exit(2);
    }

    String cond = result.rest.first;
    String input = result.rest.length > 1 ? result.rest[1] : '-';

    return Options(input, result['delimiter'], cond, result['let']);
  }
}

Future<void> execute(Options options) async {
  Stream<List<int>> input;
  if (options.input == '-') {
    input = stdin;
  } else {
    final file = File(options.input);
    // Check if file exists
    if (!await file.exists()) {
      stderr.writeln("Input file ${options.input} does not exist!");
      exit(2);
    }
    input = await file.openRead();
  }

  final evaluator = Evaluator.compile(options.condition);

  final lines = input.transform(utf8.decoder).transform(LineSplitter());

  await for (String line in lines) {
    final parts = line.split(options.delimiter);

    final vars = <String, dynamic>{};

    for (int i = 0; i < parts.length; i++) {
      vars["\$$i"] = parts[i];
    }

    if (evaluator.evaluate(vars)) {
      stdout.writeln(line);
    }
  }
}
