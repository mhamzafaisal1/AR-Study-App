//
//  Utitlities.swift
//  ARStudy
//
//  Created by Abdullah on 09/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit

class Utilities {
    
    static func inputWhiteView(withTextField textField: UITextField, text: String) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 10)
        
        view.addSubview(textField)
        textField.centerY(inView: view, leftAnchor: label.rightAnchor, paddingLeft: 15)
        textField.anchor(right: view.rightAnchor, paddingRight: 10)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .lightGray
        
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        view.addSubview(dividerView)
        dividerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }
    
}
