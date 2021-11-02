import 'dart:io';

import 'anchor_sort.dart';

extension Name on FileSystemEntity {
  String get name {
    return path.split('/').last.split(r'\').last;
  }
}

abstract class TGTBListItem {}

class TGTBBundle with Anchor {
  static const _root = 'test/test_dir_1/Bundles/';
  static const _addOn = 'Bundle_';
  String get _date => _dir.name.substring(_addOn.length, _addOn.length + 10);
  String get _uniqueKey => DateTime.now().millisecondsSinceEpoch.toString();
  String _path(String date) => _root + _addOn + date + '_' + _uniqueKey;

  late Directory _dir;

  Directory get directory => _dir;
  List<int> get bundleAnchor => anchor;

  TGTBBundle.formDirectory(this._dir) {
    // maybe add a check if _dir is valid
    anchorFromDir(_dir);
  }

  TGTBBundle.createNew() {
    var date = DateTime.now().toString().substring(0, 10);
    _dir = Directory(_path(date))..createSync();
    anchorToDir(_dir);
  }

  TGTBBundle.createBelow(TGTBBundle otherBundle) {
    _dir = Directory(_path(otherBundle._date))..createSync();
    linkTo(otherBundle);
    anchorToDir(_dir);
  }

  void moveBelow(TGTBBundle otherBundle) {
    _dir = _dir.renameSync(_path(otherBundle._date));
    linkTo(otherBundle);
    anchorToDir(_dir);
  }

  void moveTop() {
    var date = DateTime.now().toString().substring(0, 10);
    _dir = _dir.renameSync(_path(date))..createSync();
    newAnchor();
    anchorToDir(_dir);
  }
}

class TGTBPage extends TGTBListItem with Anchor {
  static const _addOn = 'Page_';
  String get _uniqueKey => DateTime.now().millisecondsSinceEpoch.toString();
  String get _name => _addOn + _uniqueKey;

  static const _fileName = 'entry.json';

  late Directory _dir;
  Directory get directory => _dir;
  List<int> get pageAnchor => anchor;
  TGTBBundle get bundle => TGTBBundle.formDirectory(_dir.parent);

  TGTBPage.fromDirectory(this._dir) {
    anchorFromDir(_dir);
  }

  TGTBPage.createNew(TGTBBundle bundle) {
    var path = bundle.directory.path + '/' + _name;
    _dir = Directory(path)..createSync(recursive: true);
    anchorToDir(_dir);
  }

  TGTBPage.createBelow(TGTBPage otherPage) {
    var bundle = otherPage.bundle;
    var path = bundle.directory.path + '/' + _name;
    _dir = Directory(path)..createSync(recursive: true);
    linkTo(otherPage);
    anchorToDir(_dir);
  }

  void moveTopOfBundle(TGTBBundle bundle) {
    var path = bundle.directory.path + '/' + _name;
    _dir = _dir.renameSync(path);
    newAnchor();
    anchorToDir(_dir);
  }

  // File pageContent;
  // Directory bundleDir;
  // List<int> bundleAnchor;
  // Directory pageDir;
  // List<int> pageAnchor;
  // File pageContent;

  // TGTBPage(
  //   this.bundleDir,
  //   this.bundleAnchor,
  //   this.pageDir,
  //   this.pageAnchor,
  //   this.pageContent,
  // );

  // TGTBPage.fromDirectory(Directory dir) {
  //   pageContent = File(dir.path + '/' + _fileName);
  //   anchorFromDir(dir);
  // }
}

///
///
///
// addPage(List<TGTBListItem> list, int index) {
//   TGTBPage newPage;
//   if (index == 0) {
//     var bundleDirPath = DateTime.now().toIso8601String();
//     var bundleDir = Directory('test/test_dir_1/bundles/' + bundleDirPath);
//     var bundleAnchor =
//     var newPage =
//         TGTBPage(bundleDir, bundleAnchor, pageDir, pageAnchor, pageContent);
//   } else {
//     newPage =
//         TGTBPage(bundleDir, bundleAnchor, pageDir, pageAnchor, pageContent);
//   }
//   list.insert(index, newPage);
// }

addSpacer() {}

addSpacerAt(int index) {}
addPageAt(int index) {}
