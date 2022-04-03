//
//  ProfileController.swift
//  ARStudy
//
//  Created by Abdullah on 09/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
            configureUser()
        }
    }
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = APP_RED
        button.setTitle("Save", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32/2
        
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 100, height: 100)
        iv.layer.cornerRadius = 50
        iv.image = UIImage(named: "profile-2")
        return iv
    }()
    
    private let fullNameTextField: UITextField = {
        return UITextField()
    }()
    
    private lazy var fullNameView: UIView = {
        let view = Utilities.inputWhiteView(withTextField: fullNameTextField, text: "Full Name", containsTop: true)
        return view
    }()
    
    private let instituteTextField: UITextField = {
        return UITextField()
    }()
    
    private lazy var instituteNameView: UIView = {
        let view = Utilities.inputWhiteView(withTextField: instituteTextField, text: "Institute", containsTop: false)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.isEnabled = false
        tf.alpha = 0.5
        return tf
    }()
    
    private lazy var emailView: UIView = {
        let view = Utilities.inputWhiteView(withTextField: emailTextField, text: "Email ID", containsTop: false)
        return view
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(APP_RED, for: .normal)
        button.setDimensions(width: 70, height: 40)
        button.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        return button
    }()
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        
        configureUI()
    }
    
    //MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { (user) in
            self.user = user
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        self.title = "Profile"
        
        fullNameTextField.delegate = self
        instituteTextField.delegate = self
        emailTextField.delegate = self
        
        configureNavigationBar()
        
        view.addSubview(profileImageView)
        profileImageView.centerX(inView: self.view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        
        
        let inputStack = UIStackView(arrangedSubviews: [fullNameView, instituteNameView, emailView])
        inputStack.axis = .vertical
        
        view.addSubview(inputStack)
        inputStack.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10)
        
        view.addSubview(signOutButton)
        signOutButton.anchor(top: inputStack.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: 15)
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.leftBarButtonItem?.tintColor = APP_RED
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    func configureUser() {
        emailTextField.text = user?.email
        instituteTextField.text = user?.institute
        fullNameTextField.text = user?.fullname
    }
    
    //MARK: - Handlers
    
    @objc func doneTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func saveButtonTapped() {
        
        guard let id = user?.uid else { return }
        
        //user cant update his email.
        let updates = [
            "fullname": fullNameTextField.text,
            "institute": instituteTextField.text
        ]
        
        UserService.shared.updateUser(id: id, updates: updates) { (error, ref) in
            if let updateError = error {
                Utilities.showAlert(withMessage: updateError.localizedDescription, target: self)
                return
            }
            
            // Successfully updated data
            
            Utilities.showAlert(withMessage: "Successfully updated data", target: self)

        }
    
    }
    
    @objc func signOutTapped() {
        
        let logoutAlert = UIAlertController(title: nil, message: "Log out of your account?", preferredStyle: UIAlertController.Style.alert)

        logoutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.signUserOut()
        }))

        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            logoutAlert.dismiss(animated: true, completion: nil)
        }))

        present(logoutAlert, animated: true, completion: nil)
        
                
    }
    
    func signUserOut() {
        do {
            try Auth.auth().signOut()
            
            //Remove user so that menu container shows loads again
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let containerController = keyWindow?.rootViewController as! ContainerController
            
            containerController.menuController.view.removeFromSuperview()
            containerController.menuController.removeFromParent()
            containerController.menuController = nil
            containerController.user = nil
            
            self.navigationController?.popViewController(animated: true)
            
            
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }

    }
}

extension ProfileController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
