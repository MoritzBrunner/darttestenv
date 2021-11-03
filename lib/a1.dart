import 'dart:io';

import 'anchor_sort.dart';

extension Name on FileSystemEntity {
  String get name {
    return path.split('/').last.split(r'\').last;
  }
}

abstract class ListItem {}

class Spacer extends ListItem {
  Spacer();
}

class BundleDirObject with Anchor {
  static const _root = 'test/test_dir_1/Bundles/';
  static const _addOn = 'Bundle_';
  String get _date => _dir.name.substring(_addOn.length, _addOn.length + 10);
  String get _uniqueKey => DateTime.now().millisecondsSinceEpoch.toString();
  String _path(String date) => _root + _addOn + date + '_' + _uniqueKey;

  late Directory _dir;

  // Directory get directory => _dir;
  // List<int> get bundleAnchor => anchor;

  BundleDirObject.formDirectory(this._dir) {
    // maybe add a check if _dir is valid
    anchorFromDir(_dir);
  }

  BundleDirObject.createNew() {
    var date = DateTime.now().toString().substring(0, 10);
    _dir = Directory(_path(date))..createSync();
    anchorToDir(_dir);
  }

  BundleDirObject.createBelow(BundleDirObject otherBundle) {
    _dir = Directory(_path(otherBundle._date))..createSync();
    linkAnchor(otherBundle);
    anchorToDir(_dir);
  }

  void moveTop() {
    var date = DateTime.now().toString().substring(0, 10);
    _dir = _dir.renameSync(_path(date))..createSync();
    resetAnchor();
    anchorToDir(_dir);
  }

  void moveBelow(BundleDirObject otherBundle) {
    _dir = _dir.renameSync(_path(otherBundle._date));
    linkAnchor(otherBundle);
    anchorToDir(_dir);
  }
}

// this is basically a Directory() that has an anchor
class PageDirectory with Anchor {
  String path;
  PageDirectory(this.path);

  void createSync({bool recursive = false}) {
    var dir = Directory(path)..createSync(recursive: recursive);
    anchorToDir(dir);
  }

  void linkPageDirectory(PageDirectory other) {
    Directory(path).renameSync(other.path);
    path = other.path;
    linkAnchor(other);
    anchorToDir(dir);
  }

  void renameSync(String newPath) {
    Directory(path).renameSync(newPath);
  }
}

some() {
  Directory('').renameSync(newPath);
}

/// This is the programaticaly representation of a PageFolder.
/// It holds the Directory(path) to the FileSystemObject as well as
/// the Anchor that is stored in that FileSystemObject.
/// This is basicaly an advanced version of a Directory()
class PageDirObject extends ListItem with Anchor {
  static const _addOn = 'Page_';
  String get _uniqueKey => DateTime.now().millisecondsSinceEpoch.toString();
  String get _name => _addOn + _uniqueKey;

  late Directory _dir;
  Directory get directory => _dir;
  // List<int> get pageAnchor => anchor;
  // TGTBBundleDirectory get bundle =>
  //     TGTBBundleDirectory.formDirectory(_dir.parent);

  PageDirObject.fromDirectory(this._dir) {
    anchorFromDir(_dir);
  }

  // TGTBPageDirectory.createNew(Directory bundle) {
  //   var path = bundle.path + '/' + _name;
  //   _dir = Directory(path)..createSync();
  //   anchorToDir(_dir);
  // }

  PageDirObject.createBelow2(PageDirObject pageDirObject) {
    // you get this from index+1
    var path = pageDirObject.directory.parent.path + '/' + _name;
    // here it might be sinnvoll to make a getter to get the parent directory but it would not save much words
    // the whole directory object is not needed
    _dir = Directory(path)..createSync();
    linkAnchor(pageDirObject);
    anchorToDir(_dir);
  }
  PageDirObject.createBelow(Directory bundle, List<int> anchor) {
    var bundle = otherPage.bundle;
    var path = bundle.directory.path + '/' + _name;
    _dir = Directory(path)..createSync();
    linkAnchor(otherPage);
    anchorToDir(_dir);
  }
  void moveTopOfBundle(BundleDirObject bundle) {
    var path = bundle.directory.path + '/' + _name;
    _dir = _dir.renameSync(path);
    resetAnchor();
    anchorToDir(_dir);
  }

  void moveBelow(PageDirObject otherPage) {
    var newBundle = otherPage.directory.parent;
    var newPath = newBundle.path + '/' + _name;
    _dir = _dir.renameSync(newPath);
    linkAnchor(otherPage);
    anchorToDir(_dir);
  }

  move(ListItem item) {
    if (item is Spacer) {
      resetAnchor();
    } else if (item is PageDirObject) {
      var newBundle = item.directory.parent;
      var newPath = newBundle.path + '/' + _name;
      _dir = _dir.renameSync(newPath);
      linkAnchor(item);
    }
    anchorToDir(_dir);
  }

  void mvBlew(PageDirObject otherPage) {
    moveToDir(otherPage.directory.parent);
    linkToOtherPage(otherPage);
  }

  void moveToDir(Directory dir) {
    var newPath = dir.path + '/' + _name;
    _dir = _dir.renameSync(newPath);
  }

  void rstnch() {
    resetAnchor();
    anchorToDir(_dir);
  }

  void linkToOtherPage(PageDirObject otherPage) {
    linkAnchor(otherPage);
    anchorToDir(_dir);
  }
}

class Page {
  String content;
  Page(this.content);
}

class Entry {
  static const fileName = 'entry.txt';
  late String content;

  Entry.fromDirectory(Directory dir) {
    var path = dir.path + '/' + fileName;
    content = File(path).readAsStringSync();
  }

  void edit(String newText) {
    content = newText;
  }

  void toDirectory(Directory dir) {
    var path = dir.path + '/' + fileName;
    File(path).writeAsStringSync(content);
  }
}

///
/// Input:
/// index of insertion
/// - create folder at copy from index+1
