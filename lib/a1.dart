import 'dart:io';

import 'anchor_sort.dart';

abstract class TGTBListItem {}

class TGTBSpacer extends TGTBListItem {}

extension Name on FileSystemEntity {
  String get name {
    return path.split('/').last.split(r'\').last;
  }
}

class TGTBBundle with Anchor {
  static const root = 'test/test_dir_1/bundles/';
  static const addOn = 'Bundle_';
  static String uniqueKey() => DateTime.now().millisecondsSinceEpoch.toString();

  static String path(String date) => root + addOn + date + '_' + uniqueKey();

  Directory _dir;
  Directory get dir => _dir;
  TGTBBundle._(this._dir);

  String get date => _dir.name.substring(addOn.length, addOn.length + 10);

  factory TGTBBundle() {
    var date = DateTime.now().toString().substring(0, 10);
    return TGTBBundle._(Directory(path(date)));
  }

  TGTBBundle.fromDirectory(this._dir) {
    anchorFromDir(_dir);
  }

  void moveTo(TGTBBundle otherBundle) {
    _dir = Directory(path(otherBundle.date));
    linkTo(otherBundle);
  }
}

class TGTBBundle2 with Anchor {
  static const root = 'test/test_dir_1/bundles/';
  static const addOn = 'Bundle_';

  String _date = DateTime.now().toString().substring(0, 10);
  String _uniqueKey = DateTime.now().millisecondsSinceEpoch.toString();

  String get date => _date;
  // String get uniqueKey => _uniqueKey;

  Directory get directory {
    var path = root + addOn + _date + '_' + _uniqueKey;
    return Directory(path);
  }

  TGTBBundle2();

  TGTBBundle2.fromDirectory(Directory dir) {
    var name = dir.name;
    _date = name.substring(addOn.length, addOn.length + 10);
    _uniqueKey = name.substring(addOn.length + 10);
    anchorFromDir(dir);
  }

  void moveTo(TGTBBundle2 otherBundle) {
    _date = otherBundle.date;
    _uniqueKey = DateTime.now().millisecondsSinceEpoch.toString();
    linkTo(otherBundle);
  }
}

class TGTBPage extends TGTBListItem with Anchor {
  Directory bundleDir;
  List<int> bundleAnchor;
  Directory pageDir;
  List<int> pageAnchor;
  File pageContent;

  TGTBPage(
    this.bundleDir,
    this.bundleAnchor,
    this.pageDir,
    this.pageAnchor,
    this.pageContent,
  );

  // TGTBPage.linked(TGTBPage otherPage) {}
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
