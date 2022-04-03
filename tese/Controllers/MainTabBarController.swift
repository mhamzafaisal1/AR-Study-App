//
//  MainTabBarController.swift
//  ARStudy
//
//  Created by Abdullah on 23/04/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import CBFlashyTabBarController

class MainTabBarController: CBFlashyTabBarController {
    
    //MARK: - Properties
    
    private var selectedBook: Book
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .white
        button.setDimensions(width: 50, height: 50)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        isMotionEnabled = true
        motionTransitionType = .autoReverse(presenting: .slide(direction: .left))
        
        super.viewDidLoad()
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isMotionEnabled = false
    }
    
    init(book: Book) {
        selectedBook = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        self.tabBar.barStyle = .black
        self.tabBar.tintColor = UIColor(red: 215/255, green: 56/255, blue: 94/255, alpha: 1)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 15)
        
        let liveVideoController = LiveVideoViewController(book: selectedBook, iban: selectedBook.IBAN)
        liveVideoController.tabBarItem.title = "Video"
        liveVideoController.tabBarItem.image = UIImage(systemName: "video.fill")
        
        let notesViewcontroller = NotesViewController(book: selectedBook)
        notesViewcontroller.tabBarItem.title = "Notes"
        notesViewcontroller.tabBarItem.image = UIImage(systemName: "book.fill")
        
        let modelViewController = ModelViewController(book: selectedBook)
        modelViewController.tabBarItem.title = "Models"
        modelViewController.tabBarItem.image = UIImage(systemName: "square.stack.3d.up.fill")
        
        viewControllers = [liveVideoController, modelViewController, notesViewcontroller]
    }
    
    //MARK: - Handlers
    
    @objc func backButtonTapped() {
        isMotionEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
}
