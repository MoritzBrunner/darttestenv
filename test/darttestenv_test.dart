import 'dart:collection';
import 'dart:io';

import 'package:darttestenv/darttestenv.dart';
import 'package:test/test.dart';

void main() {
  test('se', () {
    var l = [];
    for (var i = 0; i < 7; i++) {
      l.add(Anchor(i));
      sleep(Duration(milliseconds: 103));
    }
    var attachmentRegister = HashMap<Anchor, List<Anchor>>();
    attachmentRegister[l[0]] = [];
    attachmentRegister[l[1]] = [l[3]];
    attachmentRegister[l[2]] = [];
    attachmentRegister[l[3]] = [l[5]];
    attachmentRegister[l[4]] = [];
    attachmentRegister[l[5]] = [];
    attachmentRegister[l[6]] = [];

    var s = Stopwatch()..start();
    var chain = knotAChain(attachmentRegister, <Anchor>[l[1]]);
    s.stop();

    for (var a in chain) {
      print(a.key);
    }
    print(s.elapsedMicroseconds);
  });
  test('be', () {
    var l = <Anchor>[];
    for (var i = 0; i < 3; i++) {
      l.add(Anchor(i));
      sleep(Duration(milliseconds: 103));
    }

    l[2].linkTo(l[0]);

    sort(l, false);
  });
}
