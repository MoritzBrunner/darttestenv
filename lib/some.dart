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
///   optional bundle: anchor of bundle must be renamed but necessary if self finding or creating, only makes sense if they have anchors
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
/// create a spacer
/// var index = where spacer has been inserted
/// File side:
/// - create new folder, name form bundle of index-1 in list
/// - create anchor file, anchor link to bundle form index-1 in list
/// - move all pages form the old folder to the new
///   get address index+1 put in list, if index+2 is page (and not spacer) put address in list, if index+x is spacer break
///   each address in list rename to folder and page_1 2 3 > problem because some systems 123 other 321 > page_unique key (later make a clean name function)
/// - done
/// 
/// delete a spacer
/// var index = where spacer got removed
/// File side:
/// - move all pages to the upper folder
///   get address index put in list, if index+1 is page (and not spacer) put address in list, if index+x is spacer break
///   each address in list rename to folder from index-1 and page_j+1 j+2 j+3 (j = page name index-1) and link each anchor mass linking not possible with anchors because DTN, sort by page name not possible because some systems sort 123 other 321, it is possible with sleep function but than maybe microseconds?
/// 
/// 
/// dont use anchor when using anchor slower is than renaming 
/// give pages a hidden file placement that contains page number (duplicates ahead) and bundle anchor (useless if it gets moved)
/// 
/// posibilities:
/// - use anchor with microseconds so mass linking becomes fast
/// - use anchor with milliseconds but mass linking becomes slow fast
/// - use number, needs renaming of all other (no just the same ones that also need anchor change, but with creation in between a lot need renaming), not safe when individual pages get removed
/// - use register together with unique keys, not safe when individual pages get removed, complete order is lost when register is lost
/// 
/// 
/// 
/// 
/// 
/// /// create a spacer
/// var index = where spacer has been inserted
/// File side:
/// - create new folder, name form bundle of index-1 in list
/// - create anchor file, anchor link to bundle form index-1 in list
/// - move all pages form the old folder to the new
///   get address index+1 put in list, if index+2 is page (and not spacer) put address in list, if index+x is spacer break
///   each address in list rename to folder and page_unique key (later make a clean name function)
/// - done
/// 
/// 
/// /// delete a spacer
/// var index = where spacer got removed
/// File side:
/// - move all pages to the upper folder
///   get address index put in list, if index+1 is page (and not spacer) put address in list, if index+x is spacer break
///   each address in list {rename to folder from index-1 and page_unique key, link each anchor to the anchor index-n} (later make a clean name function)
/// - delete folder from index
/// - done
/// 
/// /// move a spacer
/// File side:
/// - a combination of create and delete
