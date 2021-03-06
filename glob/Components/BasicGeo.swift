//
//  BasicGeo.swift
//  glob
//
//  Created by Louis Foster on 7/6/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import Foundation
import SceneKit

protocol BasicGeoProtocol {
    var verts: [SCNVector3]? { get }
    var indices: [UInt8]? { get }
    var morphs: [[SCNVector3]]? { get }
    var model: SCNNode { get }
}

class BasicGeo: SCNNode, BasicGeoProtocol {
    
    // MARK: Properties
    
    var face = 0
    
    private(set) var verts: [SCNVector3]?
    
    private(set) var indices: [UInt8]?
    
    private(set) var morphs: [[SCNVector3]]?
    
    private(set) var model: SCNNode = SCNNode()
    
    // MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    override init() {
        super.init()
        
        self.addChildNode(self.model)
        self.verts = [SCNVector3]()
        self.indices = [UInt8]()
        self.morphs = [[SCNVector3]]()
        
        self.setVerts(completion: self.setGeometry)
    }
    
    // MARK: Setup
    
    // Create verts then call a function to set the geo
    private func setVerts(completion: () -> Void) {
        
        // Values per vector
        let stride = 3
        let vertArray = CubeBuilder.vertValues[self.face]
        let count = vertArray.count
        if count > 0 {
            let vertCount = count / stride
            
            // For each set of values per vector, get the values, create a vector
            // and add it to the array of vectors
            for v in 0..<vertCount {
                let offset = v * stride
                let values = Array(vertArray[offset..<offset+stride])
                self.verts?.append(SCNVector3(values[0], values[1], values[2]))
            }
        }
        
        self.indices?.append(contentsOf: CubeBuilder.pointIndices[self.face])
        
        self.face += 1
        
        completion()
    }
    
    private func setGeometry() {
        
        if let _verts = self.verts, let _indices = self.indices {
            
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
            material.diffuse.contents = NSColor.gray
            geometry.firstMaterial = material
            
            // Set the node to include the geo for display in a scene
            self.model.geometry = geometry
            self.addChildNode(self.model)
        }
    }
    
    // MARK: Actions
    
    private func animateMorph() {
        
        let animation0 = CABasicAnimation(keyPath: "morpher.weights[1]")
        animation0.fromValue = 0.0
        animation0.toValue = 1.0
        animation0.autoreverses = true
        animation0.repeatCount = .infinity
        animation0.duration = 1
        self.model.addAnimation(animation0, forKey: nil)
    }
    
    public func addMorph() {
    
        if let _verts = self.verts, let _indices = self.indices {
            
            var morph0 = [SCNVector3]()
            var morph1 = [SCNVector3]()
            for vert in _verts {
                
                morph0.append(
                    SCNVector3(vert.x * 2.0, vert.y * 2.0, vert.z * 2.0)
                )
                morph1.append(
                    SCNVector3(vert.x * 10.0, vert.y * 10.0, vert.z * 10.0)
                )
            }
            
            self.morphs?.append(morph0)
            self.morphs?.append(morph1)
            
            let sources0: [SCNGeometrySource] = [
                SCNGeometrySource(vertices: morph0)
            ]
            let elements0: [SCNGeometryElement] = [
                SCNGeometryElement(indices: _indices, primitiveType: .triangles)
            ]
            let geometry0 = SCNGeometry(sources: sources0, elements: elements0)
            
            let sources1: [SCNGeometrySource] = [
                SCNGeometrySource(vertices: morph1)
            ]
            let elements1: [SCNGeometryElement] = [
                SCNGeometryElement(indices: _indices, primitiveType: .triangles)
            ]
            let geometry1 = SCNGeometry(sources: sources1, elements: elements1)
            
            let morpher = SCNMorpher()
            morpher.targets.append(geometry0)
            morpher.targets.append(geometry1)
            self.model.morpher = morpher
            
            self.animateMorph()
        }
    }
    
    public func updateVerts() {
        
        if self.face < CubeBuilder.pointIndices.count {
        
            self.setVerts(completion: self.setGeometry)
        }
    }
    
    public func getJSON() -> Data? {
        
        if let _verts = self.verts, let _indices = self.indices, let _morphs = self.morphs {
            
            let obj3d = Loader3DObject(vectors: _verts, indices: _indices, morphs: _morphs)
            if let json = Loader3D.toJSON(obj3d) {
                
                return json
            }
        }
        
        return nil
    }
}
