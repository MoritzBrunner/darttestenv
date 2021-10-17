import 'dart:collection';

/// Let me explain the situation.
/// We have a vertical list of pages in the app.
/// Inside the app you can:
/// - move pages up and down (reorder the list).
/// - throw pages away.
/// - add new pages wherever you want.
/// - write on pages.
///
/// The pages are stored inside the devices filesystem and you can also acces
/// them there.
/// - take pagefiles out and move them to an external harddrive for example.
/// - drop pagefiles in from an external harddrive.
///

/// Anchors got created to memorize the order/position of pages in a vertical list.
/// A page can be an Anchor page timestamp timeline universal
/// always find their place no mater what happend or where they come form
/// they find their place means there is no central hub that can be deleted and
/// no renaming is happening and informatino is spread out so less vounerable
///
/// Anchors can be grounded or linked to an other Anchor.
/// Grounded means it has a fixed place in time (its name is the timestamp and
/// from when the anchor was created).
/// Linked means at some it point got taken form its original place moved else
/// where to an other anchor. When this happens they take a note to which anchor
/// they got linked (because its name is now no longer the correct place where
/// it is on the timeline) its name changes to the time of movement so tey cant
/// get mixed up with other anchor also getting linked to this anchor and
/// because the time of last moved will always be higher than the previously
/// linked one the one with the higher name is on top.

class Anchor {
  final int key;
  int name = DateTime.now().millisecondsSinceEpoch;
  List<Anchor> linkedTo = [];

  Anchor(this.key);

  void linkTo(Anchor otherAnchor) {
    name = DateTime.now().millisecondsSinceEpoch;
    linkedTo = otherAnchor.linkedTo + [otherAnchor];
  }

  Anchor get prime => linkedTo.first;
  bool get isNotLinked => linkedTo.isEmpty;
}

/// Creates an hashMap with a Anchors:<Anchors>[] key value pair.
/// Explaination:
/// We get an unordered list of Anchors form the FileSystem.
/// Later we iterate through all Anchors and every Anchor (if its linked) holds
/// information to which other Anchor it is linked.
/// We need to let the Anchor it is linked to know that it has an attachment.
/// Yes this way around because it alows decentralized data
///
typedef HMala = HashMap<Anchor, List<Anchor>>;
HMala blankAttachmentHashMap(List<Anchor> list) {
  var hashMap = HashMap<Anchor, List<Anchor>>();
  for (var anchor in list) {
    hashMap[anchor] = [];
  }
  return hashMap;
}

/// Anchors that are gounded are sorted by timestamp.
/// To each gounded Anchor the Anchors that are linked to it get attached.
/// Put all in a big list.

List<Anchor> sort(List<Anchor> allAnchors, bool c) {
  /// Anchors that are grounded will get added here as value with their name or
  /// or their primes name as key.
  /// I use a splay tree map here because:
  /// - it sorts its keys by it self (the grounded Anchors need to be sorted by
  ///   timeStamp which is either its name or the name of its prime)
  /// - it is O(log(n)) searchable (we need to check if grounded.name already
  ///   exists before adding a new grounded with the same potential name)
  /// - it is self balancing which is useless here but it ticks the other boxes
  ///   and nothing else does
  var groundedAnchorsRegister = SplayTreeMap<int, Anchor>();
  var attachmentRegister = blankAttachmentHashMap(allAnchors);

  for (var anchor in allAnchors) {
    if (anchor.isNotLinked) {
      groundedAnchorsRegister[anchor.name] = anchor;
    } else {
      for (var i = anchor.linkedTo.length - 1; i >= 0; i--) {
        if (attachmentRegister.containsKey(anchor.linkedTo[i])) {
          attachmentRegister[anchor.linkedTo[i]]!.add(anchor);
          break;
        }
        if (i == 0) {
          if (groundedAnchorsRegister.containsKey(anchor.prime.name)) {
            if (groundedAnchorsRegister[anchor.prime.name]!.name <
                anchor.name) {
              attachmentRegister[anchor]!
                  .add(groundedAnchorsRegister[anchor.prime.name]!);
              groundedAnchorsRegister[anchor.prime.name] = anchor;
            } else {
              attachmentRegister[groundedAnchorsRegister[anchor.prime.name]]!
                  .add(anchor);
            }
          } else {
            groundedAnchorsRegister[anchor.prime.name] = anchor;
          }
        }
      }
    }
  }

  var sortedAnchors = <Anchor>[];
  for (var primeAnchor in groundedAnchorsRegister.values) {
    var chain = knotAChain(attachmentRegister, <Anchor>[primeAnchor]);
    if (c) print(chain.map((e) => e.key));
    sortedAnchors.addAll(chain);
  }
  return sortedAnchors;
}

/// when the anchors prime does not exist this anchor itselve will become the prime

adjustPrime(HMala attachmentRegister,
    SplayTreeMap<int, Anchor> primeAnchorsRegister, Anchor anchor) {
  var registerdAnchor = primeAnchorsRegister[anchor.prime.name]!;
  // var
  if (registerdAnchor.name < anchor.name) {
    attachmentRegister[anchor]!.add(primeAnchorsRegister[anchor.prime.name]!);
    primeAnchorsRegister[anchor.prime.name] = anchor;
  } else {
    attachmentRegister[primeAnchorsRegister[anchor.prime.name]]!.add(anchor);
  }
}

List<Anchor> knotAChain(HMala attachmentRegister, List<Anchor> chain) {
  if (attachmentRegister[chain.last]!.isEmpty) return chain;
  for (var link in attachmentRegister[chain.last]!
    ..sort((linkA, linkB) => linkB.name.compareTo(linkA.name))) {
    chain.add(link);
    knotAChain(attachmentRegister, chain);
  }
  return chain;
}
