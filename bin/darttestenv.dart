import 'dart:io';
import 'dart:math';

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
    File(dir.path + '/' + entryFileName)
      ..createSync(recursive: true)
      ..writeAsStringSync(text);
    anchorToDir(dir);
  }
}

void main() {
  const test_dir_1 = 'test/test_dir_1';
  const test_dir_2 = 'test/test_dir_2';

  if (!Directory(test_dir_1).existsSync()) {
    Directory(test_dir_1).createSync(recursive: true);
    print('created Directory test_dir_1');
  }
  if (!Directory(test_dir_2).existsSync()) {
    Directory(test_dir_2).createSync(recursive: true);
    print('created Directory test_dir_2');
  }

  var workingDirectory = test_dir_1;

  var allObjects = <TestObject>[];

  while (true) {
    print('command:');
    var command = stdin.readLineSync();

    if (command == 'dir') {
      print('Nr.:');
      var dir = int.parse(stdin.readLineSync() ?? '0');
      if (dir == 2) {
        workingDirectory = test_dir_2;
      } else {
        workingDirectory = test_dir_1;
      }
      allObjects.clear();
    }
    if (command == 'cl') {
      allObjects = crateListOfObjects(Directory(workingDirectory));
    }

    if (command == 'ls') {
      print(workingDirectory.substring(5));
      listAllObjects(allObjects);
    }

    if (command == 'add') {
      var newPath = workingDirectory + '/page_${Random().nextInt(10000)}';
      var newObj = TestObject(Directory(newPath));
      allObjects.add(newObj);
      newObj.save();
    }

    if (command == 'addd') {
      print('how many:');
      var amount = int.parse(stdin.readLineSync() ?? '0');
      for (var i = 0; i < amount; i++) {
        var newPath = workingDirectory + '/page_${Random().nextInt(10000)}';
        var newObj = TestObject(Directory(newPath));
        allObjects.add(newObj);
        newObj.save();
        sleep(Duration(milliseconds: 33));
      }
    }

    if (command == 'sort') {
      var s = Stopwatch()..start();
      AnchorSort<TestObject>()(allObjects);
      print(s.elapsedMicroseconds);
    }

    if (command == 'shuffle') {
      allObjects.shuffle();
    }

    if (command == 'edit') {
      print('Object index:');
      var objectIndex = int.parse(stdin.readLineSync() ?? '0');
      var object = allObjects[objectIndex];
      object.text = stdin.readLineSync() ?? 'empty';
      object.save();
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
