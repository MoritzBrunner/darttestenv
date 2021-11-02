
// import 'dart:io';

// import 'anchor_sort.dart';

// class TGTBBundle2 with Anchor {
//   static const root = 'test/test_dir_1/bundles/';
//   static const addOn = 'Bundle_';

//   String _date = DateTime.now().toString().substring(0, 10);
//   String _uniqueKey = DateTime.now().millisecondsSinceEpoch.toString();

//   String get date => _date;
//   // String get uniqueKey => _uniqueKey;

//   Directory get directory {
//     var path = root + addOn + _date + '_' + _uniqueKey;
//     return Directory(path);
//   }

//   TGTBBundle2();

//   TGTBBundle2.fromDirectory(Directory dir) {
//     var name = dir.name;
//     _date = name.substring(addOn.length, addOn.length + 10);
//     _uniqueKey = name.substring(addOn.length + 10);
//     anchorFromDir(dir);
//   }

//   void moveTo(TGTBBundle2 otherBundle) {
//     _date = otherBundle.date;
//     _uniqueKey = DateTime.now().millisecondsSinceEpoch.toString();
//     linkTo(otherBundle);
//   }
// }