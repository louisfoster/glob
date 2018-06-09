//
//  GameViewController.swift
//  glob
//
//  Created by Louis Foster on 7/6/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import SceneKit

class GameViewController: NSViewController {
    
    // MARK: UI Properties
    
    @IBOutlet
    private var sceneView: SCNView?
    
    @IBOutlet
    private var addQuadButton: NSButton?
    
    // MARK: Properties
    
    var basicGeo: BasicGeo?
    
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
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // Loading of basic object
        self.basicGeo = BasicGeo()
        if let _basicGeo = self.basicGeo {
        
            scene.rootNode.addChildNode(_basicGeo)
        }
        
        // retrieve the SCNView
        if let _sceneView = self.sceneView {
        
            // set the scene to the view
            _sceneView.scene = scene
            
            // allows the user to manipulate the camera
            _sceneView.allowsCameraControl = true
            
            // configure the view
            _sceneView.backgroundColor = NSColor.black
        }
    }
    
    /*
    override func viewDidDisappear() {
        // maybe stop scene actions/rendering etc?
    }
     */
    
    // MARK: Actions
    
    @IBAction func addQuadButtonPress(_ sender: NSButton) {
        self.basicGeo?.updateVerts()
    }
    
}
