//
//  ObjectBuilder.swift
//  globViewer
//
//  Created by Louis Foster on 9/6/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import UIKit
import SceneKit

class ObjectBuilder: SCNNode {
    
    // MARK: Properties
    
    private var verts: [SCNVector3]?
    
    private var indices: [UInt8]?
    
    private var model: SCNNode?
    
    // MARK: Setup
    
    // Create verts then call a function to set the geo
    private func setVerts(vertexData: [CGFloat], completion: () -> Void) {
        
        // Values per vector
        let stride = 3
        let count = vertexData.count
        if count > 0 {
            let vertCount = count / stride
            
            // For each set of values per vector, get the values, create a vector
            // and add it to the array of vectors
            for v in 0..<vertCount {
                let offset = v * stride
                let values = Array(vertexData[offset..<offset+stride])
                self.verts?.append(SCNVector3(values[0], values[1], values[2]))
            }
        }
        
        completion()
    }
    
    private func setGeometry() {
        
        guard let _model = self.model, let _verts = self.verts, let _indices = self.indices else {
            fatalError("Could not create geometry")
        }
        
        // Loader for the verticies
        let sources: [SCNGeometrySource] = [
            SCNGeometrySource(vertices: _verts)
        ]
        
        // Loader for the indices and setting the primitive (tris)
        let elements: [SCNGeometryElement] = [
            SCNGeometryElement(indices: _indices, primitiveType: .triangles)
        ]
        
        // Create the geo from the vert and ind loaders
        let geometry = SCNGeometry(sources: sources, elements: elements)
        
        // Add a basic material to the geo
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.gray
        geometry.firstMaterial = material
        
        // Set the node to include the geo for display in a scene
        _model.geometry = geometry
    }
    
    // MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(pathToData: String)")
    }
    
    // Pass the path to the JSON file
    init(asset: String) {
        super.init()
        
        guard let path = Bundle.main.path(forResource: "Supporting Files/\(asset)", ofType: "json") else {
            fatalError("Failed to get data path")
        }
        
        guard let content = try? String(contentsOfFile: path, encoding: .utf8),
            let data = content.data(using: .utf8) else {
            fatalError("Failed to get json data")
        }
        
        let modelData = Loader3DObject(json: data)
        
        self.verts = [SCNVector3]()
        self.indices = modelData.indices
        self.model = SCNNode()
        
        guard let _model = self.model, let _vertices = modelData.vertices else {
            fatalError("Failed to create object")
        }
        
        self.addChildNode(_model)

        self.setVerts(vertexData: _vertices, completion: self.setGeometry)

        self.spin()
    }
    
    // MARK: Actions
    
    private func spin() {
        
        let rad = 30 * (CGFloat.pi / 180)
        
        self.runAction(
            SCNAction.repeatForever(
                SCNAction.rotate(by: rad,
                                 around: SCNVector3(1, 1, 1),
                                 duration: 1
                )
            )
        )
    }
}
