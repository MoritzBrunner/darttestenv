import 'dart:io';
import 'dart:math';

import 'package:darttestenv/darttestenv.dart';

void main() {
  List<Anchor> allAnchors = [];

  while (true) {
    print('command:');
    var command = stdin.readLineSync();

    if (command == 'ls') {
      listAnchors(allAnchors);
    }

    if (command == 'sort') {
      allAnchors = sort(allAnchors, false);
    }

    if (command == 'sortx') {
      allAnchors = sort(allAnchors, true);
    }

    if (command == 'shuffle') {
      allAnchors.shuffle();
    }

    if (command == 'add') {
      allAnchors.add(Anchor(Random().nextInt(1000)));
    }

    if (command == 'addd') {
      for (var i = 0; i < 10; i++) {
        allAnchors.add(Anchor(Random().nextInt(1000)));
        sleep(Duration(milliseconds: 103));
      }
    }

    if (command == 'link') {
      print('Anchor index:');
      var anchorIndex = int.parse(stdin.readLineSync() ?? '0');
      var anchor = allAnchors[anchorIndex];
      print('Link to which Anchor:');
      var otherAnchorIndex = int.parse(stdin.readLineSync() ?? '0');
      var otherAnchor = allAnchors[otherAnchorIndex];
      anchor.linkTo(otherAnchor);
    }

    if (command == 'del') {
      print('Anchor index:');
      var anchorIndex = int.parse(stdin.readLineSync() ?? '0');
      allAnchors.removeAt(anchorIndex);
    }

    if (command == 'q') {
      break;
    }
  }
}

void listAnchors(List<Anchor> allAnchors) {
  var c = 0;
  for (var anchor in allAnchors) {
    var i = c < 10 ? '0$c' : '$c';
    var k = '${anchor.key}';
    if (anchor.key < 10) {
      k = '00${anchor.key}';
    } else if (anchor.key < 100) {
      k = '0${anchor.key}';
    }
    var l = '${anchor.linkedTo.map((e) => e.key).toList()}';
    print('$i - $k:${anchor.name}:$l');
    c++;
  }
}
