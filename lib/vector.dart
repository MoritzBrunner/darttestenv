import 'dart:collection';

/// it is just one big vector that goes to n dimensions, n = vector.length
/// if things are on the same line the one with the longer last vector goes first
///
///
/// how to convert vector into list
/// straight forward approarch
/// - you take every vector
/// - you sort every first of every vector
/// - than you sort every second of every vector
/// - than third usw...
///
///
///
/// tricky approach
/// - you make a register of everyone who is here vecort.last
/// - you attach every verctor.last to the vector.last.previous (if not existant .previous.previous usw.. if a fork happens you can either sort by vector.last highest or vector.lenght both works)
/// - you knot chains with the register
/// (this skips going through the whole vector for every vector, maybe you have to try both)
///

///
/// 20        0.05                0.05
/// 5         0.2                 0.2
/// 5,10      0.2, 0.1            0.1
/// 5,10,18   0.2, 0.1, 0.003
/// 5,10,11   0.2, 0.1, 0.09      0.01
/// 5,8       0.2, 0.125
/// 5,8,13    0.2, 0.125, 0.77
/// 3         0.333
/// 3,14      0.333, 0.071
///
///
///
///
///
///
///
///
///
/// Rules:
/// - single values must be higher than their , values
/// - n is higher than n+1
///
///
///
/// 20            20
/// 5             5
/// 10, 5         0.105
/// 18, 10, 5     0.018105
/// 11, 10, 5     0.011105
/// 8, 5          1.6
/// 13, 8, 5
/// 3             0.333
/// 1, 3
///
///
///
/// 20
/// 5[10]
///
///

/// it is a vector but you cant do anything with it
/// just do like you did it and give things very long discriptive names

class Vector {
  // this is the vector that points to me -0A>
  var vector = <int>[DateTime.now().millisecondsSinceEpoch];

  List<int> call() => vector;

  void addTo(Vector otherVector) {
    vector = otherVector() + [DateTime.now().millisecondsSinceEpoch];
  }
}

HashMap<int, List<int>> blankAttachmentHashMap(List<int> list) {
  var hashMap = HashMap<int, List<int>>();
  for (var anchor in list) {
    hashMap[anchor] = [];
  }
  return hashMap;
}

sort(List<Vector> allVectors) {
  for (var vector in allVectors) {}
}

/// Anchor because it gives things attached to it a fixed place
class Anchor {
  var attachedTo;
  var stock;
}

/// point of a plant where things branch form
/// the trunk continues
/// Branch holds leaves
/// Leaves are the vicinity
class Node {
  var stem; // fist in trunk is where its connected to the ground
  var branch; // vicinity
}

/// Run changes in the register and database parallel
/// with the "find latest existing one" the lenght of the vector becomes arbitrary

class Page {
  var uniqueKey;
  var name;
  var anchor;
}

/// cvs contains only [213, 234, 236, 238]
/// A) date is always upmost and fist in anchor dictates bundle
/// B) sort how ever you want Bundle comes form Directory, will create long anchors but anchors are constat time anyway, but you could move individual pages from the filesystem no problem

/// Approach: where cvs contains only the anchor
/// - free movement of individual pages in file system
/// - long anchors but armortized constant time
/// - DateTimeNow of page creation is name (not when given a date) or time of movement/link
/// - bundles are determined form dir name // what happens if you move a page manually to a wrong bundle
///
/// clean form foreign entities
///
/// FileSystem
/// root/bundle/page/.anchor.cvs [987, 978, 987, 987]
/// List<File> anchorFiles = listSync.recursive true
///
/// for each file in anchorsFiles => Register.add(Page.formFile)
/// 
/// Page.fromFile(file)
///   bundle = file.parent.parent.name
///   pageContent = File(file.parent/entry.json)
///   anchor = file.read;
///   get name => anchor.last
///
/// Register<Page>
/// []
/// sort()
///   attachmentRegister hashHap create form Page.name : []
///   SplayList; // contains pages connected directly to timeline, sorts it self
/// 
///   if(page.anchor.lengh == 1) SplayList[page.name] = page 
///   else
///     for(var i = anchor.length - 2, i > 0, i--) // start from the second to last because last is page it self
///       if(anchor[i] exists in attachmentRegister) 
///         AttReg[anchor[i]].add(page) 
///         break; 
///       else 
///         // ! what if allready exists ! AttReg[anchor.first].add(page) // every sub sequent will get added normaly and later like everybody else sorted, but will there be a problem in know a chain if there is a page.name that does not exist?
///         // SplayList[anchor.first] = page // if no ancestor page exists in file system than this page will still have the place where it was originaly moved
///       
///   now knot a chain with attachmentRegister
///
///   
///
/// ListView.builder((list, index) => WidgetPage(Register[index].pageContent))
///
/// WidgetPage(File file){}
///
///
///
///
///
