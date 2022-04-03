//
//  AddPageModel.swift
//  ARStudy
//
//  Created by Abdullah on 14/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

struct AddPageModel {
    
    private let realm = try! Realm()
    
    func save(page: Page, inBook book: Book) {
        
        do {
            try realm.write {
                book.pages.append(page)
            }
        } catch {
            print("Error saving context:  \(error)")
        }
        
    }
    
    func addLocalAndCloudPage(title: String, bookID: String, userID: String, inBook book: Book) {
        let page = PageData(title: title, note: "", bookID: book.bookID, userID: userID)
        
        PageService.shared.registerPage(pageData: page) { (err, ref) in
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            guard let pageID = ref.key else { return }
            
            let page = Page()
            page.title = title
            page.userID = userID
            page.bookID = bookID
            page.note = ""
            page.pageID = pageID
            
            self.save(page: page, inBook: book)
        }

    }
    
    func addLocalPage(withData pageData: [String: Any], id: String, inBook book: Book) {
        let page = Page()
        page.title = pageData["title"] as? String ?? ""
        page.userID = pageData["userID"] as? String ?? ""
        page.bookID = pageData["bookID"] as? String ?? ""
        page.note = pageData["note"] as? String ?? ""
        page.pageID = id
        
        self.save(page: page, inBook: book)
    }
    
}
