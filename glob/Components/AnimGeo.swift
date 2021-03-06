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
    
    private(set) var animation0: CABasicAnimation?
    
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
            let _geometry = SCNGeometry(sources: sources, elements: elements)
            
            // Add a basic material to the geo
            let material = SCNMaterial()
            material.diffuse.contents = NSColor.gray
            _geometry.firstMaterial = material
            
            // Set the node to include the geo for display in a scene
            self.model.geometry = _geometry
            
            self.setBones()
        }
    }
    
    func setBones() {
        
        var bones: [SCNNode] = [SCNNode]()
        for boneName in IBones {
            let node = SCNNode()
            node.name = boneName
            bones.append(node)
        }
        bones[0].addChildNode(bones[1])
        bones[0].addChildNode(bones[2])
        bones[1].position = SCNVector3(0, 3, 0)
        bones[2].position = SCNVector3(2, 0, 0)
        
        let stride = 3
        var transformMatrices: [NSValue] = [NSValue]()
        let identity = NSValue(scnMatrix4: SCNMatrix4Identity)
        transformMatrices.append(identity)
        let iBoneTranslateVectorCount = IBoneTranslateVector.count / stride
        for n in 0..<iBoneTranslateVectorCount {
            let baseIndex = n * stride
            let matrix = SCNMatrix4MakeTranslation(
                IBoneTranslateVector[baseIndex],
                IBoneTranslateVector[baseIndex + 1],
                IBoneTranslateVector[baseIndex + 2])
            let value = NSValue(scnMatrix4: SCNMatrix4Invert(matrix))
            transformMatrices.append(value)
            // Origin point matrix4
            // transform with translation vector
            // invert
            // append
        }
        
        // needs to be Float (32 bit)
        let weightBytes = MemoryLayout<Float>.size
        let weightDataCount = IBoneWeights.count * weightBytes
        let weightData = Data(bytes: UnsafeRawPointer(IBoneWeights), count: weightDataCount)
        let weights = SCNGeometrySource(data: weightData,
                                        semantic: .boneWeights,
                                        vectorCount: IBoneWeights.count,
                                        usesFloatComponents: true,
                                        componentsPerVector: 1,
                                        bytesPerComponent: weightBytes,
                                        dataOffset: 0,
                                        dataStride: weightBytes)
        
        // Perhaps these two arrays can be combined?
        let indexBytes = MemoryLayout<UInt8>.size
        let indexDataCount = IBoneIndices.count * indexBytes
        let indexData = Data(bytes: UnsafeRawPointer(IBoneIndices), count: indexDataCount)
        let indices = SCNGeometrySource(data: indexData,
                                        semantic: .boneIndices,
                                        vectorCount: IBoneIndices.count,
                                        usesFloatComponents: false,
                                        componentsPerVector: 1,
                                        bytesPerComponent: indexBytes,
                                        dataOffset: 0,
                                        dataStride: indexBytes)
        
        self.model.skinner = SCNSkinner(baseGeometry: self.model.geometry,
                                        bones: bones,
                                        boneInverseBindTransforms: transformMatrices,
                                        boneWeights: weights,
                                        boneIndices: indices)
        
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
    
    // Despite animation being enabled, animations don't work
    // This function only seems to run when prompted
    public func boneAnimation() {
        
//        let constrain = SCNDistanceConstraint(target: self.model.skinner?.bones[2])
//        constrain.maximumDistance = 7.0
//        self.model.skinner?.bones[1].constraints?.append(constrain)
        
        guard let startY = self.model.skinner?.bones[1].position.y else { return }
        let duration: CGFloat = 10.0
        let goal = 20.0 - startY
        let act = SCNAction.customAction(duration: TimeInterval(duration), action: { (node, elapsed) in
            
            let distance = goal / duration * elapsed
            node.skinner?.bones[0].position.y = startY + distance
        })
        self.model.runAction(act)
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
