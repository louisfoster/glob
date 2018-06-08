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
    var vertValues: [CGFloat] { get }
    var verts: [SCNVector3]? { get }
    var pointIndices: [UInt8] { get }
    var model: SCNNode { get }
}

class BasicGeo: SCNNode, BasicGeoProtocol {
    
    // MARK: Properties
    
    // These are the points in space to use for building tris/quads
    var vertValues: [CGFloat] = [
        0.5, -0.5, 0,
        -0.5, 0.5, 0,
        -0.5, -0.5, 0,
        0.5, 0.5, 0,
    ]
    
    private(set) var verts: [SCNVector3]?
    
    // Order of tri indices relating to the verts to be drawn
    // Each 3 = 1 tri
    // Each 6 = 1 quad
    var pointIndices: [UInt8] = [
        0, 1, 2,
        3, 1, 0
    ]
    
    private(set) var model: SCNNode = SCNNode()
    
    // MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    override init() {
        super.init()
        self.model.name = "model"
        self.addChildNode(self.model)
        self.setVerts(completion: self.setGeometry)
    }
    
    // MARK: Setup
    
    // Create verts then call a function to set the geo
    private func setVerts(completion: () -> ()) {
        // Values per vector
        let stride = 3;
        let vertCount = self.vertValues.count / stride
        // Reset our vert array
        self.verts = [SCNVector3]()
        
        // For each set of values per vector, get the values, create a vector
        // and add it to the array of vectors
        for v in 0..<vertCount {
            let offset = v * stride
            let values = Array(self.vertValues[offset..<offset+stride])
            self.verts?.append(SCNVector3(values[0], values[1], values[2]))
        }
        
        completion()
    }
    
    private func setGeometry() {
        self.model.removeFromParentNode()
        if let _verts = self.verts {
            
            // Loader for the verticies
            let n: [SCNGeometrySource] = [
                SCNGeometrySource(vertices: _verts),
                ]
            
            // Loader for the indices and setting the primitive (tris)
            let m: [SCNGeometryElement] = [
                SCNGeometryElement(indices: self.pointIndices, primitiveType: .triangles),
                ]
            
            // Create the geo from the vert and ind loaders
            let geo = SCNGeometry(sources: n, elements: m)
            
            // Add a basic material to the geo
            let material = SCNMaterial()
            material.diffuse.contents = NSColor.gray
            geo.firstMaterial = material
            
            // Set the node to include the geo for display in a scene
            self.model.geometry = geo
            self.addChildNode(self.model)
        }
    }
    
    // MARK: Actions
    public func updateVerts() {
        let newValues = self.vertValues.map { (item) -> CGFloat in
            let v = item == 0.0 ? 0.0 : (item + 0.01)
            return copysign(v, item)
        }
        self.vertValues = newValues
        self.setVerts(completion: self.setGeometry)
    }
}
