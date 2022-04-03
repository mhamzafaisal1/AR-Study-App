//
//  MenuOptionCell.swift
//  ARStudy
//
//  Created by Abdullah on 06/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit

class MenuOptionCell: UITableViewCell {

    //MARK: - Properties
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        iv.clipsToBounds = true
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - TouchAction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.iconImageView.alpha = 0.25
            self.descriptionLabel.alpha = 0.25
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.25) {
            self.iconImageView.alpha = 1
            self.descriptionLabel.alpha = 1
        }
    }
    
    //MARK: - Handlers
    func configureUI() {
        backgroundColor = .white
        
        addSubview(iconImageView)
        iconImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        iconImageView.setDimensions(width: 26, height: 26)
        
        addSubview(descriptionLabel)
        descriptionLabel.centerY(inView: self, leftAnchor: iconImageView.rightAnchor, paddingLeft: 12)
    }
}
