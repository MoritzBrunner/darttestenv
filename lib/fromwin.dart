import 'dart:collection';

import 'dart:io';

/// ## Algorithm ahead! ##

/// This is AnchorSort.
/// AnchorSort allows any Object to be sorted

/// you put in a list of all objects (that have an anchor) that you want to sort
/// it spits out a sorted list of all these objects.

/// an anchor consist of a list of anchor ids
/// anchor.last = id of this anchor
/// anchor[i] = id of an other anchor inside this anchor
abstract class Anchor {
  static const anchorFileName = '.anchor.csv';

  var anchor = <int>[DateTime.now().millisecondsSinceEpoch];

  void linkTo(Anchor otherObject) {
    anchor = otherObject.anchor + [DateTime.now().millisecondsSinceEpoch];
  }

  void anchorFromDir(Directory dir) {
    var string = File(dir.path + '/' + anchorFileName).readAsStringSync();
    anchor = string.split(',').map(int.parse).toList();
  }

  void anchorToDir(Directory dir) {
    var string = anchor.toString().replaceFirst('[', '').replaceFirst(']', '');
    var file = File(dir.path + '/' + anchorFileName)
      ..createSync(recursive: true);
    file.writeAsString(string);
  }
}

class AnchorSort<E extends Anchor> {
  List<E> call(List<E> allObjects) {
    var allAnchors = <List<int>>[];
    var reference = <int, E>{};
    for (var obj in allObjects) {
      allAnchors.add(obj.anchor);
      reference[obj.anchor.last] = obj;
    }
    var sortedAnchors = _anchorSort(allAnchors);
    allObjects.clear();
    allObjects.addAll(sortedAnchors.map((e) => reference[e]!));
    return allObjects;
  }

  List<int> _anchorSort(List<List<int>> allAnchors) {
    var reversed = (int a, int b) => b.compareTo(a);

    var attachmentRegister = HashMap<int, SplayTreeSet<int>>.fromIterable(
        allAnchors,
        key: (anchor) => anchor.last,
        value: (_) => SplayTreeSet(reversed));

    var timeline = SplayTreeMap<int, SplayTreeSet<int>>(reversed);

    for (var anchor in allAnchors) {
      if (anchor.length > 1) {
        for (var i = anchor.length - 2; i >= 0; i--) {
          if (attachmentRegister.containsKey(anchor[i])) {
            attachmentRegister[anchor[i]]!.add(anchor.last);
            break;
          } else if (i == 0) {
            timeline.putIfAbsent(anchor[i], () => SplayTreeSet(reversed));
            timeline[anchor[i]]!.add(anchor.last);
          }
        }
      } else {
        timeline.putIfAbsent(anchor.last, () => SplayTreeSet(reversed));
        timeline[anchor.last]!.add(anchor.last);
      }
    }

    var sorted = <int>[];
    for (var anchors in timeline.values) {
      sorted.addAll(_knotAChain(attachmentRegister, anchors.toList()));
    }
    return sorted;
  }

  List<int> _knotAChain(
      HashMap<int, SplayTreeSet<int>> attReg, List<int> chain) {
    if (attReg[chain.last]!.isEmpty) return chain;
    for (var pageName in attReg[chain.last]!) {
      chain.add(pageName);
      _knotAChain(attReg, chain);
    }
    return chain;
  }
}

/// For things to get sorted in the right order the SplayTreeMaps/Sets
/// need to order things highest first lowest last.
///   var reversed = (int a, int b) => b.compareTo(a)

/// This holds every anchor(name) that exist currently. They are stored as keys.
/// The value assigned to each key is a list of all other anchors(name)
/// that come directly after it (imagine a shackle (= key) everything
/// thats attached to it is in this list). These lists gets filled in the next step.
/// This is done to break down all the multydimensional vectors (imageine a tree)
/// into one dimension.
/// Otherwise we would have to recurse through every branch in every step.
/// Stored as HashMap for fast access.
///   var anchorLinkRegister = HashMap<int, SplayTreeSet<int>>.fromIterable(
///     allAnchors,
///     key: (e) => e.last,
///     value: (_) => SplayTreeSet(reversed))

/// This represents our dimension / our timeline.
/// Every anchor that has the length 1 gets added by key = name and value = list.
/// Also every anchor that has no existing anchestors gets added by key = name of
/// the dim1 ancestor and value = it self.
/// This assures that things stay where they belong even if their ancestors are gone.
/// Each value in that list is the first link of a chain of anchors(name) (the
/// attachment of other links happens with the help of the anchorLinkRegister).
/// This first links base the chains in our dimension and make them sortable by time.
///   var dimension_1 = SplayTreeMap<int, SplayTreeSet<int>>(reversed);


import 'dart:io';

import 'package:darttestenvwin/b.dart';

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
    File(dir.path + '/' + entryFileName).writeAsString(text);
    anchorToDir(dir);
  }
}

/// assign a dedicated Diretory
/// get pages in directory
/// get all pages out of direcory
///
/// link, sort, see what happens

List<TestObject> crateListOfObjects(Directory testDir) {
  var allObjects = <TestObject>[];
  for (var dir in testDir.listSync().whereType<Directory>()) {
    allObjects.add(TestObject.formDir(dir));
  }
  return allObjects;
}

void listAllObjects(List<TestObject> allObjects) {
  var count = 0;
  for (var obj in allObjects) {
    var index = count < 10 ? '0$count' : '$count';
    print('$index - ${obj.dirName}: ${obj.text} - ${obj.anchor}');
    count++;
  }
}

void main() {
  if (!Directory('test/test_dir').existsSync()) {
    Directory('test/test_dir').createSync(recursive: true);
    print('created Directory');
  }
  var allObjects = <TestObject>[];

  while (true) {
    print('command:');
    var command = stdin.readLineSync();

    if (command == 'add') {
      var newObj =
          TestObject(Directory('test/test_dir/page_${allObjects.length}'));
      allObjects.add(newObj);
      newObj.save();
    }

    if (command == 'addd') {
      print('how many:');
      var amount = int.parse(stdin.readLineSync() ?? '0');
      for (var i = 0; i < amount; i++) {
        var newObj =
            TestObject(Directory('test/test_dir/page_${allObjects.length}'));
        allObjects.add(newObj);
        newObj.save();
        sleep(Duration(milliseconds: 33));
      }
    }

    if (command == 'cl') {
      allObjects = crateListOfObjects(Directory('test/test_dir'));
    }

    if (command == 'ls') {
      listAllObjects(allObjects);
    }

    if (command == 'edit') {
      print('Object index:');
      var objectIndex = int.parse(stdin.readLineSync() ?? '0');
      var object = allObjects[objectIndex];
      object.text = stdin.readLineSync() ?? 'empty';
      object.save();
    }
    if (command == 'sort') {
      var s = Stopwatch()..start();
      AnchorSort<TestObject>()(allObjects);
      print(s.elapsedMicroseconds);
    }

    if (command == 'shuffle') {
      allObjects.shuffle();
    }

    if (command == 'link') {
      print('Object index:');
      var objectIndex = int.parse(stdin.readLineSync() ?? '0');
      var object = allObjects[objectIndex];
      print('Link to which other Object:');
      var otherObjectIndex = int.parse(stdin.readLineSync() ?? '0');
      var otherAnchor = allObjects[otherObjectIndex];
      object.linkTo(otherAnchor);
    }

    if (command == 'del') {
      print('Object index:');
      var objectIndex = int.parse(stdin.readLineSync() ?? '0');
      allObjects.removeAt(objectIndex);
    }

    if (command == 'q') {
      break;
    }
  }
}
