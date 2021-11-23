import 'dart:collection';

import 'anchor.dart';



/// This algorithm sorts objects with anchors.
/// It takes an unsorted list of objects with anchors and returns it sorted.

class AnchorSort<E extends AnchorMixin> {
  List<E> call(List<E> allObjects) {
    /// extract all anchors from the given objects and make a reference of
    /// which anchor id is linked to which object
    var allAnchors = <List<int>>[];
    var reference = <int, E>{};
    for (var obj in allObjects) {
      allAnchors.add(obj.anchor);
      reference[obj.anchor.last] = obj;
    }

    /// sort
    var sortedAnchors = anchorSort(allAnchors);

    /// clear old list and populate with new sorted objects
    allObjects.clear();
    allObjects.addAll(sortedAnchors.map((e) => reference[e]!));
    return allObjects;
  }

  List<int> anchorSort(List<List<int>> allAnchors) {
    int reversed(int a, int b) => b.compareTo(a);

    /// a reference which anchor ids are linked to which other anchor id
    /// id: {id, ...}
    var linkRegister = HashMap<int, SplayTreeSet<int>>.fromIterable(allAnchors,
        key: (anchor) => anchor.last, value: (_) => SplayTreeSet(reversed));

    /// key value pair of anchor ids that are not linked.
    /// key determines the order. values later used as seeds to grow chains in
    /// that order
    var notLinked = SplayTreeMap<int, SplayTreeSet<int>>(reversed);

    /// go through all anchors to populate notLinked and linkRegister
    for (var anchor in allAnchors) {
      /// anchors of length 1 are not linked
      if (anchor.length == 1) {
        // unique, if douplicate override
        notLinked[anchor.last] = SplayTreeSet(reversed)..add(anchor.last);
        continue;
      }

      /// this goes through the anchor chain in reverse, finds the first
      /// existing match and saves it in linkRegister
      bool linkFound = false;
      for (var i = anchor.length - 2; i >= 0; i--) {
        if (linkRegister.containsKey(anchor[i])) {
          linkRegister[anchor[i]]!.add(anchor.last);
          linkFound = true;
          break;
        }
      }

      /// if no match was found the anchor is not linked but its pointer is its
      /// prime
      if (!linkFound) {
        // multiple ids that need the same prime possible
        notLinked
            .putIfAbsent(anchor.first, () => SplayTreeSet(reversed))
            .add(anchor.last);
      }
    }

    /// creates the final sorted list
    /// it uses not linked ids as seeds on which chains grow based on the
    /// information in linkRegister
    var sorted = <int>[];
    for (var ids in notLinked.values) {
      for (var id in ids) {
        sorted.addAll(_chain(linkRegister, [id]));
      }
    }

    return sorted;
  }

  /// function that knots chains from the information in the linkRegister
  List<int> _chain(HashMap<int, SplayTreeSet<int>> linkReg, List<int> chain) {
    for (var id in linkReg[chain.last]!) {
      chain.add(id);
      _chain(linkReg, chain);
    }
    return chain;
  }
}

/// This algorithm was created to combat the halfing problem.
/// The halfing problem: Image you want to sort two objects by their date of
/// creation. One was created at 12am and one was created at 6pm. Now you want
/// to retroactively add a thrid object between these two. You could assign the
/// mean date between the two existing objects to the third one that is 3pm. If
/// you would repeat that process, though in theory ther is infinite space, a
/// computer will reach its limits after about 20-30 repitions.
///
/// Sort by date of creation because it is independent and universal.
///

class CategorizedAnchors {
  final HashMap<int, List<int>> idAnchorMap;
  List<List<int>> notLinked = [], linked = [], linkNotFound = [];
  CategorizedAnchors(this.idAnchorMap) {
    categorize();
  }
  // O(n) + O(n)*O(m)? for going through each anchor if not found
  categorize() {
    for (var anchor in idAnchorMap.values) {
      if (anchor.length > 1) {
        bool found = false;
        for (var id in anchor.reversed.skip(1)) {
          found = idAnchorMap.containsKey(id);
          if (found) break;
        }
        found ? linked.add(anchor) : linkNotFound.add(anchor);
      } else {
        notLinked.add(anchor);
      }
    }
  }
}

class AnchorSortR2 {
  final List<Anchor> anchors;
  AnchorSortR2(this.anchors);

  Iterable<Anchor> notLinked(List<Anchor> anchors) =>
      anchors.where((anchor) => anchor.length == 1);

  Iterable<Anchor> linked(List<Anchor> anchors, HashSet ids) => anchors
      .where((anchor) => anchor.length > 1 && !ids.contains(anchor.last));

  Iterable<Anchor> linkNotFound(List<Anchor> anchors, HashSet ids) =>
      anchors.where((anchor) => anchor.length > 1 && ids.contains(anchor.last));

  ///
  /// the end result should be a SORTED LIST OF ALL ANCHORS
}

/// [16]
/// [9]
/// [9,13]
/// [9,13,29,60]
/// [9,13,27]
///
///
typedef Anchor = List<int>;

class AnchorSortR {
  final List<List<int>> allAnchors;
  late final List<List<int>> notLinked = [], linked = [], linkNotFound = [];
  late final HashMap<int, List<int>> idAnchorMap;
  AnchorSortR(this.allAnchors) {
    idAnchorMap = createIdAnchorMap(allAnchors);
  }

  HashMap<int, SplayTreeSet<int>> createIdLinkMap() {
    return HashMap.of(
        {for (var anchor in allAnchors) anchor.last: SplayTreeSet()});
  }

  // O(n)?, this also eliminates duplicate ids
  HashMap<int, List<int>> createIdAnchorMap(var a) {
    return HashMap.of({for (var anchor in allAnchors) anchor.last: anchor});
  }

  createMaps() {
    HashMap<int, List<int>> idAnchor = HashMap();
    HashMap<int, SplayTreeSet<int>> idLinks = HashMap();
    for (var anchor in allAnchors) {
      idAnchor[anchor.last] = anchor;
      idLinks[anchor.last] = SplayTreeSet();
    }
  }

  List<List<Anchor>> categorizeAnchors(List<Anchor> allAnchors) {
    List<Anchor> notLinked = [], linked = [], linkNotFound = [];
    for (var anchor in allAnchors) {
      if (anchor.length > 1) {
        bool found = false;
        for (var id in anchor.reversed.skip(1)) {
          found = idAnchorMap.containsKey(id);
          if (found) break;
        }
        found ? linked.add(anchor) : linkNotFound.add(anchor);
      } else {
        notLinked.add(anchor);
      }
    }
    return [notLinked, linked, linkNotFound];
  }

  late var pointerIdMap = createPointerIdMap();

  //O(n)?, maybe a normal sorted map also does it here
  SplayTreeMap<int, int> createPointerIdMap() {
    var s = <int, int>{};
    s.addAll({for (var anchor in linked) anchor.last: anchor.last});
    s.addAll({for (var anchor in linkNotFound) anchor.first: anchor.last});
    return SplayTreeMap.of(s);
  }

  late var idLinkMap = createIdLinkMap();
}

class AnchorSortR1 {
  final List<List<int>> allAnchors;
  AnchorSortR1(this.allAnchors);

  // O(n)?
  HashSet<int> createIdRegister() {
    return HashSet.from(allAnchors.map((anchor) => anchor.last));
  }

  late var idRegister = createIdRegister();
  late var notLinkedAnchors = seperateNotLinkedAnchors();
  late var linkedAnchors = seperateLinkedAnchors();
  late var lostAnchors = seperateLostAnchors();

  // O(n)
  List<List<int>> seperateNotLinkedAnchors() {
    var notLinkedAnchors = <List<int>>[];
    allAnchors.removeWhere((anchor) {
      bool notLinked = anchor.length == 1;
      if (notLinked) notLinkedAnchors.add(anchor);
      return notLinked;
    });
    return notLinkedAnchors;
  }

  // O(n)
  List<List<int>> seperateLinkedAnchors() {
    var linkedAnchors = <List<int>>[];
    allAnchors.removeWhere((anchor) {
      bool linked = anchor.length > 1;
      if (linked) linkedAnchors.add(anchor);
      return linked;
    });
    return linkedAnchors;
  }

  List<List<int>> seperateLostAnchors() {
    var lostAnchors = <List<int>>[];
    linkedAnchors.removeWhere((anchor) {
      bool lost = false;
      for (var id in anchor.reversed.skip(1)) {
        lost = !idRegister.contains(id);
        if (lost) lostAnchors.add(anchor);
      }
      return lost;
    });
    return lostAnchors;
  }

  // void populate(List<List<int>> allAnchors) {
  //   for (var anchor in allAnchors) {
  //     if (anchor.length == 1) {
  //       notLinked[anchor.last] = SplayTreeSet(reversed)..add(anchor.last);
  //       continue;
  //     }
  //     bool linkFound = false;
  //     for (var i = anchor.length - 2; i >= 0; i--) {
  //       if (linkRegister.containsKey(anchor[i])) {
  //         linkRegister[anchor[i]]!.add(anchor.last);
  //         linkFound = true;
  //         break;
  //       }
  //     }
  //     if (!linkFound) {
  //       notLinked
  //           .putIfAbsent(anchor.first, () => SplayTreeSet(reversed))
  //           .add(anchor.last);
  //     }
  //   }

  //   createChain() {
  //     var sorted = <int>[];
  //     for (var ids in notLinked.values) {
  //       for (var id in ids) {
  //         sorted.addAll(knotAChain(linkRegister, [id]));
  //       }
  //     }
  //     return sorted;
  //   }
  // }
}

List<int> knotAChain(HashMap<int, SplayTreeSet<int>> linkReg, List<int> chain) {
  for (var id in linkReg[chain.last]!) {
    chain.add(id);
    knotAChain(linkReg, chain);
  }
  return chain;
}
