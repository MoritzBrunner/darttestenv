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
    var a = BundleDirectory('test/test_dir_1/Bundles');
    sleep(Duration(milliseconds: 250));
    var b = BundleDirectory('test/test_dir_1/Bundles');
    print(b.datee);
    print(a.datee);
    print(b.path);
    print(a.path);
  });
}
