library hop_runner;

import '../test/test_runner.dart' as test_runner;
import 'package:args/args.dart';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
import 'dart:async';
import 'dart:io';

void main(List<String> args) {
  addTask('analyze', createAnalyzerTask(_getLibs));

  addTask('test', createUnitTestTask(test_runner.testCore));

  addTask('docs', createDartDocTask(['lib/echo.dart'],
        targetBranch: 'gh-pages',
        packageDir: 'packages/',
        excludeLibs: [ 'meta/', 'metadata/' ],
        linkApi: true));

  runHop(args);
}

Future<List<String>> _getLibs() {
  return new Directory('lib')
    .list(recursive: true)
    .where((FileSystemEntity fse) =>
        fse is File && fse.path.endsWith('.dart'))
    .map((File file) => file.path)
    .toList();
}

