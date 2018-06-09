//
//  MainViewController.swift
//  globViewer
//
//  Created by Louis Foster on 9/6/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import UIKit
import SceneKit

class MainViewController: UIViewController {
    
    // MARK: UI Properties
    
    @IBOutlet
    private var sceneView: SCNView?
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // Object JSON should be located in "Supporting Files" dir
        let testObj = ObjectBuilder(asset: "obj3d")
        scene.rootNode.addChildNode(testObj)
        
        // retrieve the SCNView
        if let _sceneView = self.sceneView {
            
            // set the scene to the view
            _sceneView.scene = scene
            
            // allows the user to manipulate the camera
            _sceneView.allowsCameraControl = true
            
            // configure the view
            _sceneView.backgroundColor = UIColor.black
        }
    }
}
