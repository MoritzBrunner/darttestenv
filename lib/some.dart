///
///
///   get anchor form index+1, 
///   old bundle list pages, get all anchors, anchorsort, sublist from anchor onward, get file name of each, rename and while renaming make them 1 2 3 
///   alt get anchor index+1 put in list with address, if index+2 is page (and not spacer) put in list with address (normal linked map), if index+x is spacer brake
///   now every item in list address rename to new folder with 1 2 3 
///
/// class ListItem{
/// }
///
/// class Page {
///   var bundle // so when split happens we know which bundle is effected, where we take the pages from and what date we need to copy and what anchor we need attach to No because it can also be the one above
///
/// }
///
///
/// List from ListItemList
///
///
/// class Page {
///   anchor:
///   optional bundle: anchor of bundle must be renamed but necessary if self finding
/// }
///
///
/// [..., 1, 2, 3, 4, 5, 6, 7, 8, 9, ...]
/// [..., 1, 2, 3, s, 4, 5, 6, 7, 8, 9, ...]
/// [..., 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, ...]
/// 
/// tap index 3 and 4, insert at 4
/// f: create new folder, name adopt form name of bundle at index 4-1
/// f: create anchor file, adopt form anchor form bundle of 4-1
/// list bundle sublist form one at index 4?5? rename all to new folder
/// 
/// 
/// var index = where space has been inserted
/// File side:
/// - create new folder, name form bundle of index-1 in list
/// - create anchor file, anchor link to bundle form index-1 in list
/// - move all pages form the old folder
///   get address index+1 put in list, if index+2 is page (and not spacer) put address in list, if index+x is spacer brake
///   each address in list rename to folder and page_1 2 3
/// - done