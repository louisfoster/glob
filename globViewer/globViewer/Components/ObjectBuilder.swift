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
    
    private var morphs: [[SCNVector3]]?
    
    private var model: SCNNode?
    
    // MARK: Setup
    
    // Create verts then call a function to set the geo
    private func setVerts(vertexData: [CGFloat], completion: () -> Void) {
        
        self.verts = self.buildVertexArray(vertexData: vertexData)
        
        completion()
    }
    
    private func buildVertexArray(vertexData: [CGFloat]) -> [SCNVector3] {
        // Values per vector
        let stride = 3
        let count = vertexData.count
        var vertexArray = [SCNVector3]()
        
        if count > 0 {
            let vertCount = count / stride
            
            // For each set of values per vector, get the values, create a vector
            // and add it to the array of vectors
            for v in 0..<vertCount {
                let offset = v * stride
                let values = Array(vertexData[offset..<offset+stride])
                vertexArray.append(SCNVector3(values[0], values[1], values[2]))
            }
        }
        
        return vertexArray
    }
    
    private func setGeometry() {
        
        guard let _model = self.model, let _verts = self.verts, let _indices = self.indices else {
            fatalError("Could not create geometry")
        }
        
        let geometry = buildGeometry(vertices: _verts, indices: _indices)
        
        // Add a basic material to the geo
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.gray
        geometry.firstMaterial = material
        
        // Set the node to include the geo for display in a scene
        _model.geometry = geometry
    }
    
    private func setMorphs(morphData: [[CGFloat]]) {
        
        guard let _indices = self.indices else { return }
        
        let morpher = SCNMorpher()
        var vertexArray = [SCNVector3]()
        var geometry = SCNGeometry()
        
        for morph in morphData {
            vertexArray = self.buildVertexArray(vertexData: morph)
            geometry = self.buildGeometry(vertices: vertexArray, indices: _indices)
            morpher.targets.append(geometry)
            self.morphs?.append(vertexArray)
        }
        
        self.model?.morpher = morpher
        self.animateMorph()
    }
    
    private func buildGeometry(vertices: [SCNVector3], indices: [UInt8]) -> SCNGeometry {
        
        // Loader for the verticies
        let sources: [SCNGeometrySource] = [
            SCNGeometrySource(vertices: vertices)
        ]
        
        // Loader for the indices and setting the primitive (tris)
        let elements: [SCNGeometryElement] = [
            SCNGeometryElement(indices: indices, primitiveType: .triangles)
        ]
        
        // Create the geo from the vert and ind loaders
        return SCNGeometry(sources: sources, elements: elements)
    }
    
    // MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(asset: String)")
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
        
        if let morphs = modelData.morphs, morphs.count > 0 {
            
            self.morphs = [[SCNVector3]]()
            self.setMorphs(morphData: morphs)
        }

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
    
    private func animateMorph() {
        
        let animation0 = CABasicAnimation(keyPath: "morpher.weights[1]")
        animation0.fromValue = 0.0
        animation0.toValue = 1.0
        animation0.autoreverses = true
        animation0.repeatCount = .infinity
        animation0.duration = 1
        self.model?.addAnimation(animation0, forKey: nil)
    }
}
