//
//  AuthService.swift
//  ARStudy
//
//  Created by Abdullah on 13/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let institute: String
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, withPassword password: String, completion: AuthDataResultCallback?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    func registerUser(credentials: AuthCredentials, view: UIView, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let institute = credentials.institute
        let fullname = credentials.fullname
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                return
            }
            
            //User successfully created, update data on database.
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email,
                          "institute": institute,
                          "fullname": fullname]
            
            REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        }
        
    }
    
}



