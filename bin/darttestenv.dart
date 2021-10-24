import 'dart:io';

import 'package:darttestenv/anchor_sort.dart';

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
