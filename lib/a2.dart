import 'dart:convert';
import 'dart:io';

class TgtbHashCode {
  TgtbHashCode();
}

class G {
  Directory pageDirectory;
  late List<int> bundleAnchor;
  late List<int> pageAnchor;
  late String pageHashcode;
  late String? pageDate;

  G.fromDirectory(this.pageDirectory) {
    var jsonString = File(pageDirectory.path + '/id.Json').readAsStringSync();
    var id = Id.fromJson(json.decode(jsonString));
    bundleAnchor = id.bundleAnchor;
    pageAnchor = id.pageAnchor;
    pageHashcode = id.hash;
    pageDate = id.date;
  }
}

some() {
  var bigList = <G>[]; //hashset?

  s(Directory pagesDirectory) {
    var allPageDirectories = pagesDirectory
        .listSync(recursive: true)
        .whereType<Directory>()
        .toList();

    for (var pageDirectory in allPageDirectories) {
      bigList.add(G.fromDirectory(pageDirectory));
    }
  }

  var sortedByBundleAnchor = <List<int>, List<G>>{};

  for (var g in bigList) {
    sortedByBundleAnchor.putIfAbsent(g.bundleAnchor, () => <G>[]);
    sortedByBundleAnchor[g.bundleAnchor]!.add(g);
  }

  var listOfBundleDirectories = <BundleDirectory>[];

  for (var bundleAnchorMap in sortedByBundleAnchor.entries) {
    var allPageHashes = <String>[];
    var isThereADate = <
        String>[]; // can be multiple because date does not create bundle > date automaticly creates bundle!!
    for (var g in bundleAnchorMap.value) {
      allPageHashes.add(g.pageHashcode);
      if (g.pageDate != null) {
        isThereADate.add(g.pageDate!);
      }
    }
    var bundleHash = allPageHashes.toString(); // create a combined hash somehow

    listOfBundleDirectories.add(BundleDirectory(date, bundleHash));
  }
}

class BundleDirectory {
  final String date;
  final String hash;
  BundleDirectory(this.date, this.hash);
}

class Id {
  final List<int> pageAnchor;
  final List<int> bundleAnchor;
  final String hash;
  final String? date;

  Id(this.pageAnchor, this.bundleAnchor, this.hash, this.date);

  Id.fromJson(Map<String, dynamic> json)
      : pageAnchor = json['pageAnchor'],
        bundleAnchor = json['bundleAnchor'],
        hash = json['hash'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'pageAnchor': pageAnchor,
        'bundleAnchor': bundleAnchor,
        'hash': hash,
        'date': date,
      };
}
///
/// # PageDirectory
/// Page_"PageHashCode"
/// entry.json
/// .id.json
/// 
/// 
/// # TgtbID
/// .tgtbID.Json
///   pageAnchor: [],
///   bundleAnchor: [],
///   pageHashCode: ""
///   date: "yyyy-mm-dd" // null if not set by user
/// 