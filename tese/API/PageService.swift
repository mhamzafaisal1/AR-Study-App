//
//  PageService.swift
//  ARStudy
//
//  Created by Abdullah on 14/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import Foundation
import Firebase

struct PageData {
    let title: String
    let note: String
    let bookID: String
    let userID: String
}

struct PageService {
    static let shared = PageService()
    
    func registerPage(pageData: PageData, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let title = pageData.title
        let note = pageData.note
        let bookID = pageData.bookID
        let userID = pageData.userID
        
        let values = ["title": title,
                      "note": note,
                      "bookID": bookID,
                      "userID": userID]
        
        REF_PAGES.childByAutoId().updateChildValues(values) { (err, ref) in
            if let error = err {
                print(error.localizedDescription)
                return
            }
            guard let key = ref.key else { return }
            REF_USER_BOOK_PAGES.child(userID).child(bookID).updateChildValues([key:1], withCompletionBlock: completion)
        }
    }
    
    func checkIfPageIsPresent(uid: String, bookID: String, completion: @escaping(DataSnapshot) -> Void) {
        REF_USER_BOOK_PAGES.child(uid).child(bookID).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot)
        }
        
    }
    
    func fetchPage(pageID: String, completion: @escaping([String: Any]) -> Void) {
        REF_PAGES.child(pageID).observeSingleEvent(of: .value) { (snapshot) in
            let pageData = snapshot.value as! [String: Any]
            completion(pageData)
        }
    }
    
    func updatePage(id: String, updates: [String: Any], completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        REF_PAGES.child(id).updateChildValues(updates, withCompletionBlock: completion)
        
    }
}



