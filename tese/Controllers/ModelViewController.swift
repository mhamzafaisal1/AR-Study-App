//
//  ModelViewController.swift
//  ARStudy
//
//  Created by Abdullah on 25/04/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ModelViewController: UIViewController, ARSCNViewDelegate {

    //MARK: - Properties
    
    private let sceneView = ARSCNView()
    
    private let selectedBook: Book
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        sceneView.autoenablesDefaultLighting = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        let iban = selectedBook.IBAN
        
        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "\(iban)-ModelImages", bundle: Bundle.main) {
            
            configuration.detectionImages = imagesToTrack
            
            configuration.maximumNumberOfTrackedImages = 3
            
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

    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        print("rendering")
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            DispatchQueue.main.async {
                if let name = imageAnchor.referenceImage.name {
                    plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
                    
                    let planeNode = SCNNode(geometry: plane)
                    
                    planeNode.eulerAngles.x = -Float.pi/2
                    
                    node.addChildNode(planeNode)
                    
                    if let pokeScene = SCNScene(named: "art.scnassets/\(name).scn") {
                    
                        if let pokenode = pokeScene.rootNode.childNodes.first {
//                            if name == "oddish" || name == "meowth" {
//                                pokenode.eulerAngles.x = Float.pi
//                            } else {
//                                pokenode.eulerAngles.z = -Float.pi/2
//                            }
                            pokenode.position.z += 0.05
                            planeNode.addChildNode(pokenode)
                        }
                    }
                }
            }
            
        }
        
        return node
    }
}

