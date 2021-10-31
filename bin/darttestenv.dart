import 'dart:io';
import 'dart:math';

import 'package:darttestenv/anchor_sort.dart';

// move this to archive
// Process.runSync('open', ['-a', 'terminal', '-n']);
// Process.runSync('osascript', [
//   '-e tell application "Terminal"',
//   //'-e tell application "System Events" to keystroke "n" using {command down}',
//   '-e set position of window 1 to {800, 1}',
//   '-e do script "cd development"',
//   '-e end tell',
// ]);

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

const test_dir_1 = 'test/test_dir_1';
const test_dir_2 = 'test/test_dir_2';

var workingDirectory = test_dir_1;

var allObjects = <TestObject>[];
void main() {
  rootExists(test_dir_1);
  rootExists(test_dir_2);

  var run = true;

  while (run) {
    print('command:');
    var command = stdin.readLineSync();

    switch (command) {
      case 'open':
        openWorkingDirsWindows();
        break;
      case 'dir':
        chooseWorkingDir();
        break;
      case 'cl':
        crateListOfObjectsFromDir();
        break;
      case 'ls':
        listAllObjectsInDir();
        break;
      case 'add':
        addNewObject();
        break;
      case 'addd':
        addMultipleNewObjects();
        break;
      case 'sort':
        var s = Stopwatch()..start();
        AnchorSort<TestObject>()(allObjects);
        print(s.elapsedMicroseconds);
        break;
      case 'shuffle':
        allObjects.shuffle();
        break;
      case 'edit':
        editObjectText();
        break;
      case 'link':
        linkTwoObjects();
        break;
      case 'del':
        deleteObject();
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
    Directory(test_dir_1).path,
    Directory(test_dir_2).path,
    '-g',
  ]);
}

void chooseWorkingDir() {
  print('Nr.:');
  var dir = int.parse(stdin.readLineSync() ?? '0');
  if (dir == 2) {
    workingDirectory = test_dir_2;
  } else {
    workingDirectory = test_dir_1;
  }
}

void addNewObject() {
  var path = workingDirectory + '/page_${Random().nextInt(10000)}';
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

void editObjectText() {
  print('Object index:');
  var objectIndex = int.parse(stdin.readLineSync() ?? '0');
  var object = allObjects[objectIndex];
  object.text = stdin.readLineSync() ?? 'empty';
  object.saveObj();
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

void deleteObject() {
  print('Object index:');
  var objectIndex = int.parse(stdin.readLineSync() ?? '0');
  allObjects.removeAt(objectIndex);
}

void crateListOfObjectsFromDir() {
  var wdir = Directory(workingDirectory);
  allObjects = <TestObject>[];
  for (var dir in wdir.listSync().whereType<Directory>()) {
    allObjects.add(TestObject.formDir(dir));
  }
  AnchorSort<TestObject>()(allObjects);
  listAllObjectsInDir();
}

void listAllObjectsInDir() {
  print(workingDirectory.substring(5));
  var count = 0;
  for (var obj in allObjects) {
    var index = count < 10 ? '0$count' : '$count';
    print('$index - ${obj.dirName}: ${obj.text} - ${obj.anchor}');
    count++;
  }
}
