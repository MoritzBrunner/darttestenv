import 'dart:collection';

import 'dart:io';

abstract class Anchor {
  static const anchorFileName = '.anchor.csv';

  var anchor = <int>[
    DateTime.now().millisecondsSinceEpoch,
    DateTime.now().millisecondsSinceEpoch + 1
  ];
  // bundle but it needs that time name because this is the way for things that got attached above to find their place if x gets deleted, their name would not be the right place
  // i feel like +1 this is a recipe for desaster

  void linkTo(Anchor otherObject, bool above) {
    var newAnchor = List<int>.from(otherObject.anchor);
    if (above) newAnchor.removeLast();
    anchor = newAnchor..add(DateTime.now().millisecondsSinceEpoch);
  }

  // what happens if i want it on top?

  /// problem imagine:
  /// moving thing up but now i want it back where it was
  /// it will link to the one above, now it has no real connection to the one
  /// below exept time. so everything that was created on an other device will
  /// be apear beween the two even though i dont want that
  ///
  /// solution:
  /// you choose, if up normal
  /// if down the anchor gets copied exept the anchor.last that one is replaced by DTN then it should be above, problem: it only works once
  ///
  /// what if it is above by default

  void anchorFromDir(Directory dir) {
    var string = File(dir.path + '/' + anchorFileName).readAsStringSync();
    anchor = string.split(',').map(int.parse).toList();
  }

  void anchorToDir(Directory dir) {
    var string = anchor.toString().replaceFirst('[', '').replaceFirst(']', '');
    File(dir.path + '/' + anchorFileName)
      ..createSync(recursive: true)
      ..writeAsStringSync(string);
  }
}

class AnchorSort<E extends Anchor> {
  List<E> call(List<E> allObjects) {
    var allAnchors = <List<int>>[];
    var reference = <int, E>{};
    for (var obj in allObjects) {
      allAnchors.add(obj.anchor);
      reference[obj.anchor.last] = obj;
    }
    var sortedAnchors = _anchorSort(allAnchors);
    allObjects.clear();
    allObjects.addAll(sortedAnchors.map((e) => reference[e]!));
    return allObjects;
  }

  List<int> _anchorSort(List<List<int>> allAnchors) {
    int reversed(int a, int b) => b.compareTo(a);

    var attachmentRegister = HashMap<int, SplayTreeSet<int>>.fromIterable(
        allAnchors,
        key: (anchor) => anchor.last,
        value: (_) => SplayTreeSet(reversed));

    var timeline = SplayTreeMap<int, SplayTreeSet<int>>(reversed);

    for (var anchor in allAnchors) {
      for (var i = anchor.length - 2; i >= 0; i--) {
        if (attachmentRegister.containsKey(anchor[i])) {
          attachmentRegister[anchor[i]]!.add(anchor.last);
          break;
        } else if (i == 0) {
          timeline.putIfAbsent(anchor.first, () => SplayTreeSet(reversed));
          timeline[anchor.first]!.add(anchor.last);
        }
      }
    }

    var sorted = <int>[];
    for (var anchors in timeline.values) {
      sorted.addAll(_knotAChain(attachmentRegister, anchors.toList()));
    }
    return sorted;
  }

  List<int> _knotAChain(
      HashMap<int, SplayTreeSet<int>> attReg, List<int> chain) {
    if (attReg[chain.last]!.isEmpty) return chain;
    for (var pageName in attReg[chain.last]!) {
      chain.add(pageName);
      _knotAChain(attReg, chain);
    }
    return chain;
  }
}

/// an anchor consist of a list of anchor ids
/// anchor.last = id of this anchor
/// anchor[i] = id of an other anchor inside this anchor

/// For things to get sorted in the right order the SplayTreeMaps/Sets
/// need to order things highest first lowest last.
///   var reversed = (int a, int b) => b.compareTo(a)

/// This holds every anchor(name) that exist currently. They are stored as keys.
/// The value assigned to each key is a list of all other anchors(name)
/// that come directly after it (imagine a shackle (= key) everything
/// thats attached to it is in this list). These lists gets filled in the next step.
/// This is done to break down all the multydimensional vectors (imageine a tree)
/// into one dimension.
/// Otherwise we would have to recurse through every branch in every step.
/// Stored as HashMap for fast access.
///   var anchorLinkRegister = HashMap<int, SplayTreeSet<int>>.fromIterable(
///     allAnchors,
///     key: (e) => e.last,
///     value: (_) => SplayTreeSet(reversed))

/// This represents our dimension / our timeline.
/// Every anchor that has the length 1 gets added by key = name and value = list.
/// Also every anchor that has no existing anchestors gets added by key = name of
/// the dim1 ancestor and value = it self.
/// This assures that things stay where they belong even if their ancestors are gone.
/// Each value in that list is the first link of a chain of anchors(name) (the
/// attachment of other links happens with the help of the anchorLinkRegister).
/// This first links base the chains in our dimension and make them sortable by time.
///   var dimension_1 = SplayTreeMap<int, SplayTreeSet<int>>(reversed);
