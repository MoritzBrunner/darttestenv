import 'dart:io';

abstract class Anchor {
  static const anchorFileName = '.anchor.csv';

// int anchor = DateTime.now().millisecondsSinceEpoch;
//   var chain = <int>[];
//   int ring = DateTime.now().millisecondsSinceEpoch;

  var anchor = <int>[
    DateTime.now().millisecondsSinceEpoch,
    DateTime.now().millisecondsSinceEpoch + 1
  ];
  // bundle but it needs that time name because this is the way for things that got attached above to find their place if x gets deleted, their name would not be the right place
  // i feel like +1 this is a recipe for desaster

  void linkTo(Anchor otherObject, bool above) {
    var newAnchor = List<int>.from(otherObject.anchor);
    if (above) newAnchor.removeLast();
    anchor = newAnchor..add(DateTime.now().millisecondsSinceEpoch);
  }

  // what happens if i want it on top?

  /// problem imagine:
  /// moving thing up but now i want it back where it was
  /// it will link to the one above, now it has no real connection to the one
  /// below exept time. so everything that was created on an other device will
  /// be apear beween the two even though i dont want that
  ///
  /// solution:
  /// you choose, if up normal
  /// if down the anchor gets copied exept the anchor.last that one is replaced by DTN then it should be above

  void anchorFromDir(Directory dir) {
    var string = File(dir.path + '/' + anchorFileName).readAsStringSync();
    anchor = string.split(',').map(int.parse).toList();
  }

  void anchorToDir(Directory dir) {
    var string = anchor.toString().replaceFirst('[', '').replaceFirst(']', '');
    File(dir.path + '/' + anchorFileName)
      ..createSync(recursive: true)
      ..writeAsStringSync(string);
  }
}
