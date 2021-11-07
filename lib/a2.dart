import 'dart:convert';
import 'dart:io';

/// allright:
/// Pages contain:
/// - bundle anchor
///   app starts, list all existing bundles and attach all corresponding pages to them
///   sort the bundles and all bundle folders will be created (yes every time the app starts we create folders and delete empty ones (well that seams expensive and what problem does it fix? so everyting is based on pages, jeah but for what, people are as happy if they can move their bundles they dont need to move individual pages thats why they bundled them in the first place))
///
/// - page anchor
///   this is how the pages are sorted inside bundle
/// - hashCode
///   created from the page content + anchor every time the page is eddited (in app, when you edit it in folder i cant do shit exept recreate all fucking hashcodes of all pages whenever the app starts just to correct that one shit youve done, and needles to say that creates a lot of 99.99% unnecessary computation and app startup time (maybe) to only haphasardly fix an uncommon problem)
///   this hashcode will be attached to the directory name so that
///

///
/// People are..
/// - allowed to move bunldes to backup and back in.
/// - allowed tinker with pages inside bundle. (hash is out)
/// - not allowed to move pages from bundles.
///   pro: pages do not need millisecond anchors (optential other problems?) which allows easy multy creation
///   con: what happens if people do it

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
    for (var g in bundleAnchorMap.value) {
      allPageHashes.add(g.pageHashcode);
    }
    var bundleHash = allPageHashes.toString(); // create a combined hash somehow

    String? isThereADate;
    for (var g in bundleAnchorMap.value) {
      if (g.pageDate != null) {
        isThereADate = g.pageDate; // decide on a date to use if multiple
      }
    }
    // get date String form millisecondsSinceEpoch
    var date = isThereADate ?? bundleAnchorMap.key.last.toString();

    listOfBundleDirectories.add(BundleDirectory(date, bundleHash));
  }

  for (var bundleDirectory in listOfBundleDirectories) {
    bundleDirectory.toDirectory('rootPath');
  }

  for (var bundleAnchorMap in sortedByBundleAnchor.entries) {
    for (var g in bundleAnchorMap.value) {
      g.pageDirectory = g.pageDirectory.renameSync(newPath);
    }
  }
}

class BundleDirectory {
  final String date;
  final String hash;
  BundleDirectory(this.date, this.hash);

  toDirectory(String rootPath) {
    Directory(rootPath + 'Bundle_' + date + '_hash').createSync();
    // automaticaly only creates if it does not exist
  }
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
