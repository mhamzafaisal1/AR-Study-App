//
//  AppDelegate.swift
//  tese
//
//  Created by Abdullah on 23/04/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var hasAlreadyLaunched :Bool!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //retrieve value from local store, if value doesn't exist then false is returned
        hasAlreadyLaunched = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        //check first launched
        if (hasAlreadyLaunched)
        {
            hasAlreadyLaunched = true
        }else{
            UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
        }
        
        do {
            _ = try Realm()
        } catch {
            print("error initializing new realm \(error)")
        }
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func sethasAlreadyLaunched(){
        hasAlreadyLaunched = true
    }


}

