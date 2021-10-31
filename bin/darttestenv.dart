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
  TestObject(this.dir);

  String text = 'empty';

  String get dirName => dir.name;

  TestObject.formDir(this.dir) {
    text = File(dir.path + '/' + entryFileName).readAsStringSync();
    anchorFromDir(dir);
  }

  void saveObj() {
    File(dir.path + '/' + entryFileName)
      ..createSync(recursive: true)
      ..writeAsStringSync(text);
  }

  void saveAnchor() {
    anchorToDir(dir);
  }
}

var allObjects = <TestObject>[];
void main() {
  rootExists('test/test_dir_1');
  rootExists('test/test_dir_2');

  var run = true;

  while (run) {
    print('command:');
    var command = stdin.readLineSync();

    switch (command) {
      case 'open':
        openWorkingDirsWindows();
        break;
      case 'cl':
        crateListOfObjectsFromDir();
        break;
      case 'add':
        addMultipleNewObjects();
        break;
      case 'link':
        linkTwoObjects();
        break;
      case 'q':
        run = false;
        break;
      default:
        print('invalid command');
    }
  }
}

void rootExists(String path) {
  if (!Directory(path).existsSync()) {
    Directory(path).createSync(recursive: true);
  }
}

void openWorkingDirsWindows() {
  Process.runSync('open', [
    Directory('test/test_dir_1').path,
    Directory('test/test_dir_2').path,
    '-g',
  ]);
}

void addNewObject() {
  var path = 'test/test_dir_1/page_${Random().nextInt(10000)}';
  var newObj = TestObject(Directory(path));
  newObj.saveObj();
  newObj.saveAnchor();
  allObjects.add(newObj);
}

void addMultipleNewObjects() {
  print('how many:');
  var amount = int.parse(stdin.readLineSync() ?? '0');
  for (var i = 0; i < amount; i++) {
    addNewObject();
    sleep(Duration(milliseconds: 33));
  }
}

void linkTwoObjects() {
  print('Object index:');
  var objectIndex = int.parse(stdin.readLineSync() ?? '0');
  var object = allObjects[objectIndex];
  print('Link to which other Object:');
  var otherObjectIndex = int.parse(stdin.readLineSync() ?? '0');
  var otherAnchor = allObjects[otherObjectIndex];
  object.linkTo(otherAnchor);
  object.saveAnchor();
}

void crateListOfObjectsFromDir() {
  var dir = Directory('test/test_dir_1');
  allObjects = <TestObject>[];
  for (var objDir in dir.listSync().whereType<Directory>()) {
    allObjects.add(TestObject.formDir(objDir));
  }
  AnchorSort<TestObject>()(allObjects);
  listAllObjectsInDir();
}

void listAllObjectsInDir() {
  var count = 0;
  for (var obj in allObjects) {
    var index = count < 10 ? '0$count' : '$count';
    print('$index - ${obj.dirName}: ${obj.text} - ${obj.anchor}');
    count++;
  }
}
