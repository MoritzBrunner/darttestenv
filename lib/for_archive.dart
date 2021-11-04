import 'dart:io';

import 'anchor_sort.dart';

extension Name on FileSystemEntity {
  String get name {
    return path.split('/').last.split(r'\').last;
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
    linkAnchor(otherBundle);
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
    var dir = Directory(_path(date))..createSync();
    //anchorToDir(dir);
    return TGTBBundle(dir);
  }

  void moveTo(TGTBBundle otherBundle) {
    _dir = _dir.renameSync(_path(otherBundle._date));
    linkAnchor(otherBundle);
  }
}
