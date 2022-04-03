//
//  User.swift
//  ARStudy
//
//  Created by Abdullah on 13/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let fullname: String
    let email: String
    let uid: String
    let institute: String
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.institute = dictionary["institute"] as? String ?? ""
        
    }
}
