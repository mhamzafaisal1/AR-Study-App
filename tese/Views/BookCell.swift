//
//  BookCell.swift
//  ARStudy
//
//  Created by Abdullah on 04/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit

class BookCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var book: Book? {
        didSet {
            configure()
        }
    }
    
    private let bookImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 53, height: 80)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .black
        return iv
    }()
    
    private let bookTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    private let bookIban: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGroupedBackground
        layer.cornerRadius = 10
        
        addSubview(bookImageView)
        bookImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 15)
        
        let stack = UIStackView(arrangedSubviews: [bookTitle, bookIban])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: bookImageView.rightAnchor, bottom: bottomAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        bookTitle.text = book?.title
        bookIban.text = book?.IBAN
        
        guard let iban = book?.IBAN else { return }
        
        bookImageView.image = UIImage(named: iban)
    }
    
}
