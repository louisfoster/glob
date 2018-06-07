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
 
 
 */

import Foundation
import SceneKit

class BasicGeo: SCNNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    override init() {
        super.init()
        
        // This needs to be series of coordinates in local coordinate space
        let v: [SCNVector3] = [
            SCNVector3(0.5, -0.5, 0),
            SCNVector3(-0.5, 0.5, 0),
            SCNVector3(-0.5, -0.5, 0),
            SCNVector3(0.5, 0.5, 0),
        ]
        
        // Order of tri indices relating to the verts to be drawn
        // Front facing is drawing RTL where the furthest right
        // vert is drawn and should end with furthest left (i guess?)
        let i: [UInt8] = [
            0, 1, 2, 3, 1, 0
        ]
        
        // Loader for the verticies
        let n: [SCNGeometrySource] = [
            SCNGeometrySource(vertices: v),
        ]
        
        // Loader for the indices and setting the primitive (tris)
        let m: [SCNGeometryElement] = [
            SCNGeometryElement(indices: i, primitiveType: .triangles),
        ]
        
        // Create the geo from the vert and ind loaders
        let geo = SCNGeometry(sources: n, elements: m)
        
        // Add a basic material to the geo
        let material = SCNMaterial()
        material.diffuse.contents = NSColor.gray
        geo.firstMaterial = material
        
        // Set the node to include the geo for display in a scene
        self.geometry = geo
    }
}
