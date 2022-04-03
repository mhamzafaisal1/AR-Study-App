//
//  TypeNotesViewController.swift
//  ARStudy
//
//  Created by Abdullah on 29/04/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import RealmSwift

class TypeNotesViewController: UIViewController, UITextViewDelegate {
    
    //MARK: - Properties
    
    let realm = try! Realm()
    
    private let notesTextView = CaptionTextView()
    
    private var selectedPage: Page
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        notesTextView.delegate = self
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notesTextView.text = selectedPage.note
        
        if selectedPage.note.count > 0 {
            notesTextView.placeholderLabel.text = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Every time view dissapears, data on realm is saved.
        try! realm.write {
            selectedPage.note = notesTextView.text
        }
        
        let updates = [
            "note": notesTextView.text
        ]
        
        PageService.shared.updatePage(id: selectedPage.pageID, updates: updates) { (err, ref) in
            if let error = err {
                print("DEBUG: Error saving page: \(error.localizedDescription)")
            }
        }
    }
    
    init(page: Page) {
        selectedPage = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        self.title = "Notes"
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.keyboardDonePressed))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        notesTextView.inputAccessoryView = toolBar
        
        notesTextView.isScrollEnabled = true
        view.addSubview(notesTextView)
        notesTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                             paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 215/255, green: 56/255, blue: 94/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
    }
    
    func loadText() {
        notesTextView.text = selectedPage.note
    }
    
    //MARK: - AdjustKeyboardHeight
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            notesTextView.contentInset = .zero
        } else {
            notesTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        notesTextView.scrollIndicatorInsets = notesTextView.contentInset

        let selectedRange = notesTextView.selectedRange
        notesTextView.scrollRangeToVisible(selectedRange)
    }
    
    
    //MARK: - Handlers
    
    @objc func doneTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardDonePressed() {
        view.endEditing(true)
    }
}
