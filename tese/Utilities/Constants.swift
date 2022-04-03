//
//  Constants.swift
//  ARStudy
//
//  Created by Abdullah on 05/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import Firebase

let APP_RED = UIColor(red: 230/255, green: 56/255, blue: 94/255, alpha: 1)

let STORAGE_REF = Storage.storage().reference()
let STORAGE_BOOKCOVER_IMAGES = STORAGE_REF.child("book_cover_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_BOOKS = DB_REF.child("books")
let REF_PAGES = DB_REF.child("pages")
let REF_USER_BOOK_PAGES = DB_REF.child("user-book-pages")

