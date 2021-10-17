import 'dart:collection';

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

typedef HMala = HashMap<Anchor, List<Anchor>>;
HMala blankAttachmentHashMap(List<Anchor> list) {
  var hMap = HashMap<Anchor, List<Anchor>>();
  for (var anchor in list) {
    hMap[anchor] = [];
  }
  return hMap;
}

List<Anchor> sort(List<Anchor> allAnchors, bool c) {
  var primeAnchorsRegister = SplayTreeMap<int, Anchor>();
  var attachmentRegister = blankAttachmentHashMap(allAnchors);

  for (var anchor in allAnchors) {
    if (anchor.isNotLinked) {
      primeAnchorsRegister[anchor.name] = anchor;
    } else {
      for (var i = anchor.linkedTo.length - 1; i >= 0; i--) {
        if (attachmentRegister.containsKey(anchor.linkedTo[i])) {
          attachmentRegister[anchor.linkedTo[i]]!.add(anchor);
          break;
        }
        if (i == 0) {
          if (primeAnchorsRegister.containsKey(anchor.prime.name)) {
            if (primeAnchorsRegister[anchor.prime.name]!.name < anchor.name) {
              attachmentRegister[anchor]!
                  .add(primeAnchorsRegister[anchor.prime.name]!);
              primeAnchorsRegister[anchor.prime.name] = anchor;
            } else {
              attachmentRegister[primeAnchorsRegister[anchor.prime.name]]!
                  .add(anchor);
            }
          } else {
            primeAnchorsRegister[anchor.prime.name] = anchor;
          }
        }
        // TODO: ich kann den prime nicht als prime nehmem when der prime schon
        // da ist. Bsp.: beide linken zu 2, 2 wird gelöscht, beide haben den
        // gleichen prime jetzt
        // Lösung: link den späteren zum prime (problem wenn der spätere
        // eigentlich drüber gehört (allAnchors können in belibiger reinfolge
        // reinkommen deswegen ist es keine lösung))
        // Lösungs ansatz: prime decision look which one has the higher name,
        // this one is the grounded one link the other to it. it should work
        // because the lower one can not be above the higher one because you
        // cant move the lower one bewteen the prime and the higher. i guess
        // there is still much jank possible and multiple ones must also be
        // considered.
      }
    }
  }

  var sortedAnchors = <Anchor>[];
  for (var primeAnchor in primeAnchorsRegister.values) {
    var chain = knotAChain(attachmentRegister, <Anchor>[primeAnchor]);
    if (c) print(chain.map((e) => e.key));
    sortedAnchors.addAll(chain);
  }
  return sortedAnchors;
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
