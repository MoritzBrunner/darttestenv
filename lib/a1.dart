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
  static const _root = 'test/test_dir_1/bundles/';
  static const _addOn = 'Bundle_';

  static String _uniqueKey() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  static String _path(String date) =>
      _root + _addOn + date + '_' + _uniqueKey();

  Directory _dir;
  TGTBBundle(this._dir);

  String get _date => _dir.name.substring(_addOn.length, _addOn.length + 10);

  factory TGTBBundle.createNew() {
    var date = DateTime.now().toString().substring(0, 10);
    return TGTBBundle(Directory(_path(date)));
  }

  void moveTo(TGTBBundle otherBundle) {
    _dir = Directory(_path(otherBundle._date));
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
