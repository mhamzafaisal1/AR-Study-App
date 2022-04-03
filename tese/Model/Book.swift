//
//  Book.swift
//  ARStudy
//
//  Created by Abdullah on 04/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var IBAN: String = ""
    @objc dynamic var bookID: String = ""
    @objc dynamic var numberOfPages: Int = 0
    let pages = List<Page>()
}
