//
//  Utitlities.swift
//  ARStudy
//
//  Created by Abdullah on 09/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit

class Utilities {
    
    //view for profile
    static func inputWhiteView(withTextField textField: UITextField, text: String, containsTop: Bool) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = text
        label.textColor = .lightGray
        label.setDimensions(width: 90, height: 25)
        
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 20)
        
        view.addSubview(textField)
        textField.centerY(inView: view, leftAnchor: label.rightAnchor, paddingLeft: 20)
        textField.anchor(right: view.rightAnchor, paddingRight: 10)
        
        let topDividerView = UIView()
        let bottomDividerView = UIView()
        topDividerView.backgroundColor = APP_RED
        bottomDividerView.backgroundColor = APP_RED
        
        view.addSubview(bottomDividerView)
        bottomDividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 12, height: 0.6)
        
        if containsTop {
            view.addSubview(topDividerView)
            topDividerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, height: 0.6)
        }
        
        return view
    }
    
    static func inputContainerView(textField: UITextField) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true

        view.backgroundColor = .white
        view.layer.cornerRadius = 60/2
        
        view.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.2)
        view.layer.borderWidth = 2
        
        view.addSubview(textField)
        textField.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 25)
        textField.anchor(right: view.rightAnchor, paddingRight: 10)
        
        return view
    }
    
    static func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .black
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return tf
    }
    
    static func mainButton(withText text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = APP_RED
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 30
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }
    
    static func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes:
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
             NSAttributedString.Key.foregroundColor: UIColor.black])
        
        attributedTitle.append(NSAttributedString(string: " " + secondPart, attributes:
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
             NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
    
    // Call this any where in app to show an iOS styled alert.
    
    static func showAlert(withMessage message: String, target: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        target.present(alert, animated: true, completion: nil)
    }

    
}
