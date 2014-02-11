library hop_runner;

import '../test/test_runner.dart' as test_runner;
import 'package:args/args.dart';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
import 'dart:async';
import 'dart:io';

void main(List<String> args) {

  // Add a task to execute dartanalyzer: the static analyzer.
  // The task analyzes Dart files under `lib/` directory.
  addTask('analyze', createAnalyzerTask(_expandDir('lib')));

  // Add a task to execute unit tests.
  // The task starts `testCore()` function described in `../test/test_runner.dart`.
  addTask('test', createUnitTestTask(test_runner.testCore,
        timeout: new Duration(seconds: 10)));

  // Add a task to generate documents for Dart files under `lib/` directory.
  // The documents are checked into `gh-pages` branch.
  addTask('docs', createDartDocTask(_expandDir('lib'),
        targetBranch: 'gh-pages',
        packageDir: 'packages/',
        linkApi: true));

  runHop(args);
}

/**
 * Returns a list includeing Dart files under directory specified by an argument.
 */
Future<List<String>> _expandDir(String dirName) {
  return new Directory(dirName)
    .list(recursive: true)
    .where((FileSystemEntity fse) =>
        fse is File && fse.path.endsWith('.dart'))
    .map((File file) => file.path)
    .toList();
}

