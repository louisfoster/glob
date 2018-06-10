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
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(GameViewController.onSaveAs(notification:)),
                         name: .saveAsIntent,
                         object: nil)
    }
    
    // MARK: Actions
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 3:
            self.basicGeo?.updateVerts()
        case 5:
            self.basicGeo?.addMorph()
        default:
            return
        }
    }
    
    @objc
    func onSaveAs(notification: Notification) {
        
        guard let json = self.basicGeo?.getJSON() else {
            print("failed to generate json")
            return
        }
        
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "obj3d.json"
        panel.begin { (result) in
            
            if result == NSApplication.ModalResponse.OK {
                if let saveURL = panel.url {
                    let manager = FileManager()
                    _ = manager.createFile(atPath: saveURL.path, contents: json, attributes: nil)
                }
            }
        }
    }
}
