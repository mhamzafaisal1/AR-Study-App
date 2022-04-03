//
//  BookService.swift
//  ARStudy
//
//  Created by Abdullah on 14/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import Foundation
import Firebase

struct BookService {
    static let shared = BookService()
    
    func fetchBook(uid: String, completion: @escaping(Book) -> Void) {
        
        REF_BOOKS.child(uid).observeSingleEvent(of: .value) { (snapshot) in

            guard let dictionary = snapshot.value as? [String: Any] else { return }

            let book = Book()
            
            book.title = dictionary["title"] as? String ?? ""
            book.IBAN = dictionary["IBAN"] as? String ?? ""
            book.numberOfPages = dictionary["pages"] as? Int ?? 0
            book.bookID = uid
            
            completion(book)
        }
        
    }
    
}


//This is a sample code for adding book to database.
//I wont add through here but wrote it for reference or if i may need it.



//guard let imageData = UIImage(named: "978-0-521-14779-8")?.jpegData(compressionQuality: 0.3) else { return }
//let filename = NSUUID().uuidString
//let storageRef = STORAGE_BOOKCOVER_IMAGES.child(filename)
//
//storageRef.putData(imageData, metadata: nil) { (meta, error) in
//    storageRef.downloadURL { (url, error) in
//
//        if let imageError = error {
//            print(imageError.localizedDescription)
//            return
//        }
//
//        guard let coverImageUrl = url?.absoluteString else { return }
//
//        let values = ["title": "IGCSE Biology",
//                      "IBAN": "978-0-521-14779-8",
//                      "pages": 247,
//                      "imageURL": coverImageUrl] as [String : Any]
//
//        REF_BOOKS.childByAutoId().updateChildValues(values) { (err, ref) in
//            if let err = err {
//                print(err)
//            }
//            print("Book added")
//        }
//
//    }
//
//}
