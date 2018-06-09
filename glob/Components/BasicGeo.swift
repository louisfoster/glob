//
//  BasicGeo.swift
//  glob
//
//  Created by Louis Foster on 7/6/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

/*
 
 There is no way to alter the data once it is created and rendered.
 An option may be to use: https://developer.apple.com/documentation/scenekit/scngeometrysource/1522873-geometrysourcewithbuffer
 
 However, another idea is to use an array of values, from which
 the vectors are generated and model can be displayed.
 The renderer would then need to remove and re-implement the geo/node
 whenever a new vector/tri/quad is added.
 
 What I need to know is, how to go from a point, to a tri, to a quad
 And then update references to points, so if I reuse them then the
 drawing order references its index and can update the position if
 necessary. Therefore no multiple instances of single points need to
 be referenced and updated multiple times.
 
 This is also means that if only 1 point is created, making an odd
 number of points such that there are enough quads/tri for all but 1/2
 indices then (separately) a line can be drawn between these points.
 
 
 */

import Foundation
import SceneKit

protocol BasicGeoProtocol {
    var verts: [SCNVector3]? { get }
    var indices: [UInt8]? { get }
    var model: SCNNode { get }
}

class BasicGeo: SCNNode, BasicGeoProtocol {
    
    // MARK: Properties
    
    var face = 0
    
    private(set) var verts: [SCNVector3]?
    
    private(set) var indices: [UInt8]?
    
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
    
    public func updateVerts() {
        
        if self.face < CubeBuilder.pointIndices.count {
        
            self.setVerts(completion: self.setGeometry)
        }
    }
    
    public func getJSON() -> Data? {
        
        if let _verts = self.verts, let _indices = self.indices {
            let obj3d = Loader3DObject(vectors: _verts, indices: _indices)
            if let json = Loader3D.toJSON(obj3d) {
                return json
            }
        }
        
        return nil
    }
}
