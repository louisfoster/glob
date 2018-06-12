//
//  IBuilder.swift
//  glob
//
//  Created by Louis Foster on 11/6/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import Foundation
import SceneKit

// Position verticies for the geometry mesh
public let IVerticies: [CGFloat] = [

     0.0,  0.0,  0.0, // 0
    -1.0,  4.0,  0.0, // 1
    -1.0,  0.0,  0.0, // 2
     0.0,  4.0,  0.0, // 3
     2.0,  0.0,  0.0, // 4
     0.0,  1.0,  0.0, // 5
     2.0,  1.0,  0.0, // 6
     2.0,  0.0, -1.0, // 7
     2.0,  1.0, -1.0, // 8
     0.0,  1.0, -1.0, // 9
     0.0,  4.0, -1.0, // 10
     0.0,  0.0, -1.0, // 11
    -1.0,  0.0, -1.0, // 12
    -1.0,  4.0, -1.0, // 13

]

// Position indices for the geometry mesh
public let IIndices: [UInt8] = [

    0, 1, 2,
    3, 1, 0,
    4, 5, 0,
    6, 5, 4,
    7, 6, 4,
    8, 6, 7,
    9, 3, 5,
    10, 3, 9,
    11, 8, 7,
    9, 8, 11,
    12, 10, 11,
    13, 10, 12,
    2, 13, 12,
    1, 13, 2,
    8, 5, 6,
    9, 5, 8,
    10, 1, 3,
    13, 1, 10,
    12, 0, 2,
    11, 0, 12,
    11, 4, 0,
    7, 4, 11,

]

// Bone nodes
public let IBones: [String] = [

    "center", // root node
    "top", // top control point
    "right", // right control point

]

// Bone inverse transformation (simple position vectors to be converted to transforms)
// so each 3 values is a transform for the bone from the root node
// these will then need to be calculated...
public let IBoneTranslateVector: [CGFloat] = [

    0, 3, 0,
    2, 0, 0,

]

// Number of Vectors = mesh vertices (14)
// Components per vector = max bones per mesh vertices (1)
// Component value = influence of bone of mesh vertex (1.0)

public let IBoneWeights: [Float] = [
    
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,

]

// Number of vectors = bone weight vectors (14)
// Components per vector = components per bone weight vector (1)
// Component value = index of bone corresponding to weight
public let IBoneIndices: [UInt8] = [

    0,
    1,
    0,
    1,
    2,
    0,
    2,
    2,
    2,
    0,
    1,
    0,
    0,
    1,
    
]
