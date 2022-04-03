//
//  MenuHeaderView.swift
//  ARStudy
//
//  Created by Abdullah on 08/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import Firebase

protocol MenuHeaderDelegate {
    func TappedMenuHeader()
}

class MenuHeaderView: UIView {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = "Guest User"
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "Guest@ARStudy.com"
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 70, height: 70)
        iv.image = UIImage(named: "profile-2")?.withTintColor(.white)
        return iv
    }()
    
    var delegate : MenuHeaderDelegate?
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        backgroundColor = APP_RED
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 30, paddingLeft: 10)
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 10
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: profileImageView.rightAnchor, paddingTop: 40, paddingLeft: 10)
    }
    
    func configure() {

        guard let currentUser = user else { return }
        
        self.nameLabel.text = currentUser.fullname
        self.emailLabel.text = currentUser.email

    }
    
    //MARK: - TouchAction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.nameLabel.alpha = 0.25
            self.emailLabel.alpha = 0.25
            self.profileImageView.alpha = 0.25
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.TappedMenuHeader()
        UIView.animate(withDuration: 0.25) {
            self.nameLabel.alpha = 1
            self.emailLabel.alpha = 1
            self.profileImageView.alpha = 1
        }
    }
    
}
