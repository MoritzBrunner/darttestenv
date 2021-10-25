import 'dart:io';

import 'package:darttestenv/anchor_sort.dart';
import 'package:test/test.dart';

extension Name on FileSystemEntity {
  String get name {
    return path.split('/').last.split(r'\').last;
  }
}

class TestObject with Anchor {
  static const String entryFileName = 'entry.txt';
  final Directory dir;
  String text = 'empty';
  TestObject(this.dir);

  String get dirName => dir.name;

  TestObject.formDir(this.dir) {
    text = File(dir.path + '/' + entryFileName).readAsStringSync();
    anchorFromDir(dir);
  }

  void save() {
    File(dir.path + '/' + entryFileName)
      ..create()
      ..writeAsString(text);
    anchorToDir(dir);
  }
}

void main() {
  test('test 1', () {
    TestObject.formDir(Directory('test/test_dir_1/page_8149'));
  });
}
