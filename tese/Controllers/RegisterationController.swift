//
//  RegisterationController.swift
//  ARStudy
//
//  Created by Abdullah on 13/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit

class RegisterationController: UIViewController {
    //MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let font = UIFont(name: "BetmRounded-SemiBold", size: 32)
        label.font = font
        label.text = "Sign Up"
        label.textColor = APP_RED
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = Utilities.textField(withPlaceholder: "Email ID")
        return textField
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = Utilities.inputContainerView(textField: emailTextField)
        return view
    }()
    
    private let fullNameTextField: UITextField = {
        let textField = Utilities.textField(withPlaceholder: "Full Name")
        return textField
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let view = Utilities.inputContainerView(textField: fullNameTextField)
        return view
    }()
    
    private let instituteTextField: UITextField = {
        let textField = Utilities.textField(withPlaceholder: "Institute")
        return textField
    }()
    
    private lazy var InstituteContainerView: UIView = {
        let view = Utilities.inputContainerView(textField: instituteTextField)
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let textField = Utilities.textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = Utilities.inputContainerView(textField: passwordTextField)
        return view
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = Utilities.mainButton(withText: "Sign Up")
        button.setTitleColor(APP_RED, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        let color = CGColor(srgbRed: 230/255, green: 56/255, blue: 94/255, alpha: 0.7)
        button.layer.borderColor = color
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        navigationController?.navigationBar.tintColor = APP_RED
        
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        fullNameTextField.delegate = self
        instituteTextField.delegate = self
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: self.view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        
        let inputStack = UIStackView(arrangedSubviews: [emailContainerView, fullNameContainerView, InstituteContainerView, passwordContainerView, signUpButton])
        inputStack.axis = .vertical
        inputStack.spacing = 20
        
        view.addSubview(inputStack)
        inputStack.centerX(inView: self.view, topAnchor: titleLabel.bottomAnchor, paddingTop: 20)
        inputStack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 15, paddingRight: 15)
    }
    
    @objc func handleSignUp() {
        
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        instituteTextField.endEditing(true)
        fullNameTextField.endEditing(true)
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let institute = instituteTextField.text else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, institute: institute)
        
        AuthService.shared.registerUser(credentials: credentials, view: self.view) { (error, ref) in
            
            //User successfully logged in
            let controller = ProfileController()
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
}

    //MARK: - UITextFieldDelegate

extension RegisterationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

//MARK: - ViewAdjustments
extension RegisterationController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 60
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

