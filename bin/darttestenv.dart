import 'dart:io';
import 'dart:math';

import 'package:darttestenv/anchor_sort.dart';

const root = 'test/test_dir_1/Bundle';

void main() {
  rootExists(root);

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

void listAll() {
  var all = Directory(root).listSync(recursive: true);
  for (var i in all) {
    print(i.path);
  }
}

void addPage() {
  print('where?');
  var amount = int.parse(stdin.readLineSync() ?? '0');
}

void rootExists(String path) {
  if (!Directory(path).existsSync()) {
    Directory(path).createSync(recursive: true);
  }
}

void openWorkingDirsWindows() {
  Process.runSync('open', [
    Directory(root).path,
    '-g',
  ]);
}

void addPage() {
  print('where?');
  var amount = int.parse(stdin.readLineSync() ?? '0');
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
