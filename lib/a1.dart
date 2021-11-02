import 'dart:io';

import 'anchor_sort.dart';

extension Name on FileSystemEntity {
  String get name {
    return path.split('/').last.split(r'\').last;
  }
}

abstract class TGTBListItem {}

class TGTBBundle with Anchor {
  static const root = 'test/test_dir_1/bundles/';
  static const addOn = 'Bundle_';
  static String uniqueKey() => DateTime.now().millisecondsSinceEpoch.toString();
  static String path(String date) => root + addOn + date + '_' + uniqueKey();

  String get _date => _dir.name.substring(addOn.length, addOn.length + 10);

  late Directory _dir;
  Directory get directory => _dir;

  TGTBBundle.formDirectory(this._dir) {
    anchorFromDir(_dir);
  }

  TGTBBundle.createNew() {
    var date = DateTime.now().toString().substring(0, 10);
    _dir = Directory(path(date))..createSync();
  }

  void moveTo(TGTBBundle otherBundle) {
    _dir = _dir.renameSync(path(otherBundle._date));
    linkTo(otherBundle);
    anchorToDir(_dir);
  }
}

class TGTBPage extends TGTBListItem with Anchor {
  static const _addOn = 'Page_';
  static const _fileName = 'entry.json';

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
