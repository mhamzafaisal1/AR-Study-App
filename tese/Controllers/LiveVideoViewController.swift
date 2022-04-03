//
//  LiveVideoViewController.swift
//  tese
//
//  Created by Abdullah on 23/04/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class LiveVideoViewController: UIViewController, ARSCNViewDelegate {
    
    //MARK: - Properties
    
    private let sceneView = ARSCNView()
    
    private let selectedBook: Book
    
    private let iban: String
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if let bookImagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "\(iban)-Images", bundle: Bundle.main) {
            configuration.trackingImages = bookImagesToTrack
            
            configuration.maximumNumberOfTrackedImages = 2
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
    
    init(book: Book, iban: String) {
        selectedBook = book
        self.iban = iban
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.addSubview(sceneView)
        sceneView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)

    }
    
    //MARK: - ARRendering
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        //1. Check We Have Detected An ARImageAnchor
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        //2. Create A Video Player Node For Each Detected Target
        node.addChildNode(createdVideoPlayerNodeFor(imageAnchor.referenceImage))

    }
    
    func createdVideoPlayerNodeFor(_ target: ARReferenceImage) -> SCNNode{
        
        //1. Create An SCNNode To Hold Our VideoPlayer
        let videoPlayerNode = SCNNode()
        
        //2. Create An SCNPlane & An AVPlayer
        let videoPlayerGeometry = SCNPlane(width: target.physicalSize.width, height: target.physicalSize.height)
        var videoPlayer = AVPlayer()
        
        //3. If We Have A Valid Name & A Valid Video URL The Instanciate The AVPlayer
        if let targetName = target.name,
            let validURL = Bundle.main.url(forResource: targetName, withExtension: "mp4", subdirectory: "BookData/\(iban)") {
            videoPlayer = AVPlayer(url: validURL)
            videoPlayer.play()
        }
        
        //4. Assign The AVPlayer & The Geometry To The Video Player
        videoPlayerGeometry.firstMaterial?.diffuse.contents = videoPlayer
        videoPlayerNode.geometry = videoPlayerGeometry
        
        //5. Rotate It
        videoPlayerNode.eulerAngles.x = -.pi / 2
        
        return videoPlayerNode
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if node.isHidden {
            sceneView.session.remove(anchor: anchor)
        }
    }
    
}

