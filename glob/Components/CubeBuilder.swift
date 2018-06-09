//
//  CubeBuilder.swift
//  glob
//
//  Created by Louis Foster on 9/6/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import Foundation

struct CubeBuilder {

    static let vertValues: [[CGFloat]] = [

        [
            0.5, -0.5, 0.5, // 0
            -0.5, 0.5, 0.5, // 1
            -0.5, -0.5, 0.5, // 2
            0.5, 0.5, 0.5, // 3
        ],
        
        [
            0.5, -0.5, -0.5, // 4
            0.5, 0.5, -0.5, // 5
        ],
        
        [
            -0.5, -0.5, -0.5, // 6
            -0.5, 0.5, -0.5, // 7
        ],
        
        [], [], []

    ]

    static let pointIndices: [[UInt8]] = [

        // Always Be 6 (quad)
        [
            0, 1, 2,
            3, 1, 0
        ],
        
        [
            4, 3, 0,
            5, 3, 4
        ],
        
        [
            6, 5, 4,
            7, 5, 6
        ],
        
        [
            2, 7, 6,
            1, 7, 2
        ],
        
        [
            3, 7, 1,
            5, 7, 3
        ],
        
        [
            4, 2, 6,
            0, 2, 4
        ]

    ]
}
