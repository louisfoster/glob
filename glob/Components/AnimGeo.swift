//
//  AnimGeo.swift
//  glob
//
//  Created by Louis Foster on 10/6/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import Foundation
import SceneKit

class AnimGeo: SCNNode {
    
    private(set) var verts: [SCNVector3]?
    
    private(set) var indices: [UInt8]?
    
    private(set) var morphs: [[SCNVector3]]?
    
    private(set) var model: SCNNode = SCNNode()
    
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
    
    func setVerts(completion: () -> Void) {
        // Values per vector
        let stride = 3
        let count = IVerticies.count / stride
        
        // For each set of values per vector, get the values, create a vector
        // and add it to the array of vectors
        for v in 0..<count {
            let offset = v * stride
            let values = Array(IVerticies[offset..<offset+stride])
            self.verts?.append(SCNVector3(values[0], values[1], values[2]))
        }
        
        self.indices = IIndices
        
        completion()
    }
    
    func setGeometry() {
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
    
    func setBones() {
        
        // IBones need to become [SCNNode] (use the string as the name?)
        // IBoneTranslateVector needs to become [SCNMatrix4] (or something)
        //  - apply given vector3 transform from origin point to get matrix
        //  - invert the output matrix before adding to value array
        // IBoneWeight needs to become SCNGeometry source
        //  - data is the array of floats
        //  - set semantic to "boneWeights"
        //  - vector count = array count, floatComponents is true, components = 1, bytes=memory size of CGFloat type?, offset = 0, stride = 1
        // IBoneIndices needs to become SCNGeometry source
        //  - data is the array of UInt8
        //  - set semantic to "boneIndices"
        //  - vector count = array count, floatComponents is false, components = 1, bytes=memory size of UInt8 type?, offset = 0, stride = 1
        
        
        // ----- Test what the effect of parenting bone nodes does
        // ----- Check the value of baseGeometryBindTransform (SCNSkinner)
        // ----- What is returned from the "skeleton" prop (SCNSkinner)
    }
}

/*
 
 Create and build F geo
 
 Bones (starting from single root node, which is aka "skeleton"
 Each "bone" is a node that is a control point of the animation
 
 I think bones are positioned based on their corresponding
 transform matrix in the boneInverseBindTransforms array.
 Then by applying transformations to the bone node, based
 on the boneWeights/boneIndices data, we deduce which vectors
 in the mesh(skin) are influenced and by how much.
 
 Each mesh vertex needs to somehow correspond to a set of bones.
 Vertices that are influenced by multiple bones receive and blend
 from the weights of both. I believe this is where the transforms,
 weights and indices come into play.
 
 What is the baseGeometryBindTransform?
 
 The skeleton bones are then moved according to both animations
 and constraints. The animations can dictate the timings and
 positions of certain control nodes while the contraints can
 influence other control nodes that are subordinate to the nodes
 being animated. I think...
 Inverse Kinematics (SCNIKConstraint) are a useful way to calculate and apply
 animations. Also the physics tools can help with animations.
 
 */
