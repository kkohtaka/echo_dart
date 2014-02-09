import 'package:args/args.dart';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

void main(List<String> args) {
  addTask('docs', createDartDocTask(['lib/echo.dart'],
        targetBranch: 'gh-pages',
        packageDir: 'packages/',
        excludeLibs: [ 'meta/', 'metadata/' ],
        linkApi: true));
  runHop(args);
}

