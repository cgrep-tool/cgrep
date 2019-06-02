import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

import 'package:cgrep/execute/execute.dart';

class Options {
  final List<String> ifs;

  final List<String> lets;

  final String delimiter;

  final String input;

  Options(this.input, this.delimiter, this.ifs, this.lets);

  factory Options.parse(List<String> args) {
    final parser = ArgParser()
      ..addMultiOption('on', abbr: 'n')
      ..addMultiOption('let', abbr: 'l')
      ..addOption('delimiter', abbr: 'd', defaultsTo: ',');

    final result = parser.parse(args);

    if (result.rest.length > 1) {
      stderr.writeln("Multiple input files not supported: ${result.rest}!\r\n" + parser.usage);
      exit(2);
    }

    String input = result.rest.isNotEmpty ? result.rest.first : '-';

    return Options(input, result['delimiter'], result['on'], result['let']);
  }
}

Future<void> execute(Options options) async {
  Stream<List<int>> input;
  if (options.input == '-') {
    input = stdin;
  } else {
    final file = File(options.input);
    // Check if file exists
    if(!await file.exists()) {
      stderr.writeln("Input file ${options.input} does not exist!");
      exit(2);
    }
    input = await file.openRead();
  }

  final evaluator = Evaluator.compile(options.ifs);

  final lines = input.transform(utf8.decoder).transform(LineSplitter());

  await for (String line in lines) {
    final parts = line.split(options.delimiter);

    final vars = <String, dynamic>{};

    for(int i = 0; i < parts.length; i++) {
      vars["\$$i"] = parts[i];
    }

    if(evaluator.evaluate(vars)) {
      stdout.writeln(line);
    }
  }
}
