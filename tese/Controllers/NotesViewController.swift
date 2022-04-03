//
//  NotesViewController.swift
//  ARStudy
//
//  Created by Abdullah on 23/04/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import RealmSwift

class NotesViewController: UIViewController, ARSCNViewDelegate {
    
    //MARK: - Properties
    
    let realm = try! Realm()
    
    var pageArray: Results<Page>?
    
    private var selectedPage: Page?
    
    private let selectedBook: Book
    
    private let sceneView = ARSCNView()
    
    var noteText: String?

    
    private lazy var addNotesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDimensions(width: 50, height: 50)
        button.layer.cornerRadius = 25
        button.backgroundColor = .systemBackground
        let image = UIImage(systemName: "pencil.tip.crop.circle.badge.plus")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageArray = realm.objects(Page.self)
        
        configureUI()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        let iban = selectedBook.IBAN
        
        if let bookImagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "\(iban)-Pages", bundle: Bundle.main) {
            configuration.trackingImages = bookImagesToTrack
            
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - init
    
    init(book: Book) {
        selectedBook = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.addSubview(sceneView)
        sceneView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        view.addSubview(addNotesButton)
        addNotesButton.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 70, paddingRight: 20)
        addNotesButton.disable()
        
    }
    
    func handlePageAppear(withImageAnchor bookImageAnchor: ARImageAnchor) {
        
        syncNotes()
        
        let bookImageName = bookImageAnchor.referenceImage.name!

        DispatchQueue.main.sync {
            self.pageArray = self.pageArray?.filter("title LIKE[c] %@", bookImageName)
            print("DEBUG: page is: \(self.pageArray![0].title)")
            self.selectedPage = self.pageArray?[0]
            self.noteText = self.selectedPage?.note
            
            syncNotes()
        }
        
        DispatchQueue.main.async {
            self.addNotesButton.enable()
        }
        
    }
    
    func handlePageDissapear() {
        
        print("DEBUG: page removed")
        
        DispatchQueue.main.async {
            self.addNotesButton.disable()
            
            self.selectedPage = nil
            
            //fetch pages again as currently  it has filtered pages.
            self.pageArray = self.realm.objects(Page.self)
            
            self.noteText = nil
        }
        
        if let configuration = sceneView.session.configuration {
            sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
        
    }
    
    func newLineText(fromText text: String) -> String? {
        
        var text = text
        
        let numberOfNewline = text.count / 32
        
        for x in 0...numberOfNewline {
            text.insert("\n", at: text.index(text.startIndex, offsetBy: 32*x))
        }
        
        return text
        
    }
    
    func syncNotes() {
        //The function will update notes in case they are not simmilar to the one on database.
        guard let id = selectedPage?.pageID else { return }
        
        if id == "" {
            return
        }
        
        PageService.shared.fetchPage(pageID: id) { (pageData) in
            let notes = pageData["note"] as! String
            
            try! self.realm.write {
                self.selectedPage?.note = notes
            }
            
        }
    }
    
    //MARK: - Handlers
    
    @objc func addButtonTapped() {
        
        guard let selectedPage = selectedPage else { return }
        
        let controller = TypeNotesViewController(page: selectedPage)
        let nav = UINavigationController(rootViewController: controller )
        
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - ARRendering
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.black
        
        let text = SCNText(string: newLineText(fromText: noteText!), extrusionDepth: 1)
        text.materials = [material]
        
        let textNode = SCNNode(geometry: text)
        
        //moove text relative to current position.
        textNode.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        
        let x = textNode.position.x
        let y = textNode.position.y
        let z = textNode.position.z
        
        textNode.position = SCNVector3(x-10, y, z-15)
        
        node.addChildNode(textNode)

    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let bookImageAnchor = anchor as? ARImageAnchor else { return nil }
        
        handlePageAppear(withImageAnchor: bookImageAnchor)
        
        let node = SCNNode()
        
        return node
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if node.isHidden {
            handlePageDissapear()
        }
    }

    
 
}



