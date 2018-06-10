//
//  AnimGeo.swift
//  glob
//
//  Created by Louis Foster on 10/6/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import Foundation

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
