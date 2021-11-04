import 'dart:io';

import 'package:darttestenv/a1.dart';
import 'package:darttestenv/anchor_sort.dart';
import 'package:test/test.dart';

class F with Anchor {
  int i;
  F(this.i);
}

void main() {
  test('AnchorSort quick test', () {
    var l = List.generate(5, (i) {
      sleep(Duration(milliseconds: 250));
      return F(i);
    });
    l.forEach((e) => print(e.i));
    AnchorSort<F>()(l);
    l.forEach((e) => print(e.i));
  });
  test('test 2', () {
    // var a = BundleDirectory('test/test_dir_1/Bundles');
    // PageDirectory(a).createSync();
    var l = Directory('test/test_dir_1/Bundles').listSync();
    var b = l[0];
    if (b is Directory) {
      var c = BundleDirectory.formDirectory(b);
      print(c.path);
      var ll = b.listSync();
      var p = ll[1]; // 0 is anchor.csv
      if (p is Directory) {
        var d = PageDirectory.fromDirectory(p);
        print(d.path);
      }
    }
  });
  test('link BundleDirectories', () {
    var a = BundleDirectory.newAt('test/test_dir_1/Bundles')..createSync();
    sleep(Duration(milliseconds: 250));
    BundleDirectory.newAt('test/test_dir_1/Bundles')
      ..createSync()
      ..linkDirectory(a);
  });
  test('link PageDirectories', () {
    var a = BundleDirectory.newAt('test/test_dir_1/Bundles')..createSync();
    var b = PageDirectory(a);
    sleep(Duration(milliseconds: 250));
    BundleDirectory.newAt('test/test_dir_1/Bundles')
      ..createSync()
      ..linkDirectory(a);
  });
  test('asdb', () {});
}
