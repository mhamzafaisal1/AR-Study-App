//
//  MenuController.swift
//  ARStudy
//
//  Created by Abdullah on 06/05/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MenuOptionCell"

class MenuController: UIViewController {
    
    //MARK: - Properties
    
    var user: User?
    
    var tableView: UITableView!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let font = UIFont(name: "BetmRounded-SemiBold", size: 30)
        label.font = font
        label.text = "ARStudy"
        label.textColor = APP_RED
        return label
    }()
    
    private lazy var crossButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        button.tintColor = APP_RED
        return button
    }()
    
    var delegate: HomeControllerDelegate?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newFrame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width - 80, height: self.view.frame.height)

        self.view.frame = newFrame
        
        configureUI()
        configureTableView()
        
        //only set rounded corner for right side
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        view.backgroundColor = .white
    }
    
    init(user: User?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isScrollEnabled = false
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20)
    }
    
    func configureUI() {
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        
        view.addSubview(crossButton)
        crossButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 22, paddingLeft: 20)
        
    }
    
    //MARK: - Handlers
    
    @objc func crossButtonTapped() {
        delegate?.handleMenuToggle(menuOption: nil)
    }
    
    @objc func profileHeaderViewTapped(_ view: UIView) {
        view.alpha = 0.5
    }
}

    //MARK: - UITableViewDelegate/DataSource
extension MenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //-1 as last value reseved for profile header.
        return MenuOption.allCases.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = menuOption?.description
        cell.iconImageView.image = menuOption?.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = MenuHeaderView()
        view.user = user
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.handleMenuToggle(menuOption: MenuOption(rawValue: indexPath.row))
    }
    
}
    
    //MARK: - MenuHeaderDelegate

extension MenuController: MenuHeaderDelegate {
    
    func TappedMenuHeader() {
        //gat the last mennu option
        let menuOption = MenuOption(rawValue: MenuOption.allCases.count - 1)
        delegate?.handleMenuToggle(menuOption: menuOption)
    }
    
}
