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
class PageDirectorye with Anchor {
  static const addOn = 'Page_';
  String get uniqueKey => DateTime.now().millisecondsSinceEpoch.toString();
  String get name => addOn + uniqueKey;

  String _path;
  PageDirectorye(this._path);

  Directory get _rawDir => Directory(path);
  String get path => _path;
  Directory get parent => _rawDir.parent;

  void createSync({bool recursive = false}) {
    _rawDir.createSync(recursive: recursive);
    anchorToDir(_rawDir);
  }

  void linkPageDirectory(PageDirectorye other) {
    _rawDir.renameSync(other.path);
    _path = other.path;
    linkAnchor(other);
    anchorToDir(_rawDir);
  }

  void renameSync(String newPath) {
    _rawDir.renameSync(newPath);
  }
}

/// This is basically a Directory with an Anchor.
abstract class TGTBDirectory<E extends TGTBDirectory<E>> with Anchor {
  String _path;
  TGTBDirectory(this._path);

  String get path => _path;
  Directory get parent => Directory(_path).parent;

  void createSync({bool recursive = false}) {
    var newDir = Directory(_path);
    newDir.createSync(recursive: recursive);
    anchorToDir(newDir);
  }

  /// Linkes the TGTBDirectory to an other TGTBDirectory of the same Type.
  void linkDirectory(E other);

  /// Renames this TGTBDirectory.
  Directory _renameSync(String newPath) {
    var newDir = Directory(_path).renameSync(newPath);
    _path = newPath;
    return newDir;
  }
}

/// If the user creates a [Page] a PageDirectory is created.
/// The contents of the Page are stored in files insde this Directory.
///
/// PageDirectories are located in [BundleDirectory]s.
class PageDirectory extends TGTBDirectory<PageDirectory> {
  // PageDirectories have a fixed naming convention
  static const addOn = 'Page_';
  static String uniqueKey() => DateTime.now().millisecondsSinceEpoch.toString();
  static String get name => addOn + uniqueKey();

  // PageDirectories can only be created in BundleDirectories
  PageDirectory(BundleDirectory bundle) : super(bundle.path + '/' + name);

  @override
  void linkDirectory(PageDirectory other) {
    var newPath = other.parent.path + '/' + name;
    var newDir = _renameSync(newPath);
    linkAnchor(other);
    anchorToDir(newDir);
  }

  PageDirectory.fromDirectory(Directory dir) : super(dir.path);
}

/// If the user creates a [Bundle] a BundleDirectory is created.
/// [PageDirectory]s are stored insde BundleDirectories.
class BundleDirectory extends TGTBDirectory<BundleDirectory> {
  // BundleDirectories have a fixed naming convention
  static const addOn = 'Bundle_';
  static String currentDate() => DateTime.now().toString().substring(0, 10);
  static String uniqueKey() => DateTime.now().millisecondsSinceEpoch.toString();
  static String name(String date) => addOn + date + '_' + uniqueKey();

  String _date = currentDate();
  String get date => _date;

  BundleDirectory(String path) : super(path + '/' + name(currentDate()));

  @override
  void linkDirectory(BundleDirectory other) {
    // Date is copied so they appear in the same spot in a FileExplorer
    _date = other.date;
    var newPath = other.parent.path + '/' + name(other.date);
    var newDir = _renameSync(newPath);
    linkAnchor(other);
    anchorToDir(newDir);
  }

  BundleDirectory.formDirectory(Directory dir) : super(dir.path);
}

some() {
  var a = BundleDirectory('');
  PageDirectory(a).createSync();
}

/// This is the programaticaly representation of a PageFolder.
/// It holds the Directory(path) to the FileSystemObject as well as
/// the Anchor that is stored in that FileSystemObject.
/// This is basicaly an advanced version of a Directory()
// class PageDirObject extends ListItem with Anchor {
//   static const _addOn = 'Page_';
//   String get _uniqueKey => DateTime.now().millisecondsSinceEpoch.toString();
//   String get _name => _addOn + _uniqueKey;

//   late Directory _dir;
//   Directory get directory => _dir;
//   // List<int> get pageAnchor => anchor;
//   // TGTBBundleDirectory get bundle =>
//   //     TGTBBundleDirectory.formDirectory(_dir.parent);

//   PageDirObject.fromDirectory(this._dir) {
//     anchorFromDir(_dir);
//   }

//   // TGTBPageDirectory.createNew(Directory bundle) {
//   //   var path = bundle.path + '/' + _name;
//   //   _dir = Directory(path)..createSync();
//   //   anchorToDir(_dir);
//   // }

//   PageDirObject.createBelow2(PageDirObject pageDirObject) {
//     // you get this from index+1
//     var path = pageDirObject.directory.parent.path + '/' + _name;
//     // here it might be sinnvoll to make a getter to get the parent directory but it would not save much words
//     // the whole directory object is not needed
//     _dir = Directory(path)..createSync();
//     linkAnchor(pageDirObject);
//     anchorToDir(_dir);
//   }
//   PageDirObject.createBelow(Directory bundle, List<int> anchor) {
//     var bundle = otherPage.bundle;
//     var path = bundle.directory.path + '/' + _name;
//     _dir = Directory(path)..createSync();
//     linkAnchor(otherPage);
//     anchorToDir(_dir);
//   }
//   void moveTopOfBundle(BundleDirObject bundle) {
//     var path = bundle.directory.path + '/' + _name;
//     _dir = _dir.renameSync(path);
//     resetAnchor();
//     anchorToDir(_dir);
//   }

//   void moveBelow(PageDirObject otherPage) {
//     var newBundle = otherPage.directory.parent;
//     var newPath = newBundle.path + '/' + _name;
//     _dir = _dir.renameSync(newPath);
//     linkAnchor(otherPage);
//     anchorToDir(_dir);
//   }

//   move(ListItem item) {
//     if (item is Spacer) {
//       resetAnchor();
//     } else if (item is PageDirObject) {
//       var newBundle = item.directory.parent;
//       var newPath = newBundle.path + '/' + _name;
//       _dir = _dir.renameSync(newPath);
//       linkAnchor(item);
//     }
//     anchorToDir(_dir);
//   }

//   void mvBlew(PageDirObject otherPage) {
//     moveToDir(otherPage.directory.parent);
//     linkToOtherPage(otherPage);
//   }

//   void moveToDir(Directory dir) {
//     var newPath = dir.path + '/' + _name;
//     _dir = _dir.renameSync(newPath);
//   }

//   void rstnch() {
//     resetAnchor();
//     anchorToDir(_dir);
//   }

//   void linkToOtherPage(PageDirObject otherPage) {
//     linkAnchor(otherPage);
//     anchorToDir(_dir);
//   }
// }

// class Page {
//   String content;
//   Page(this.content);
// }

// class Entry {
//   static const fileName = 'entry.txt';
//   late String content;

//   Entry.fromDirectory(Directory dir) {
//     var path = dir.path + '/' + fileName;
//     content = File(path).readAsStringSync();
//   }

//   void edit(String newText) {
//     content = newText;
//   }

//   void toDirectory(Directory dir) {
//     var path = dir.path + '/' + fileName;
//     File(path).writeAsStringSync(content);
//   }
// }

///
/// Input:
/// index of insertion
/// - create folder at copy from index+1
