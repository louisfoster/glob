//
//  Loader3D.swift
//  glob
//
//  Created by Louis Foster on 9/6/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

// Output structure for a 3D object

import Foundation
import SceneKit

protocol Loader3DObjectProtocol {
    
    var vertices: [CGFloat]? { get set }
    var indices: [UInt8]? { get }
}

public struct Loader3DObject: Loader3DObjectProtocol, Codable {
    
    var vertices: [CGFloat]?
    var indices: [UInt8]?
}

extension Loader3DObject {
    
    // From vectors
    init(vectors: [SCNVector3], indices _indices: [UInt8]) {
        
        var _vertices = [CGFloat]()
        
        for vector in vectors {
            _vertices.append(CGFloat(vector.x))
            _vertices.append(CGFloat(vector.y))
            _vertices.append(CGFloat(vector.z))
        }
        
        self.init(vertices: _vertices, indices: _indices)
    }
    
    // From JSON
    init(json: Data) {
        
        guard let parseData = try? JSONSerialization.jsonObject(with: json, options: []),
            let jsonData = parseData as? [String: Any],
            let _vertices = jsonData["vertices"] as? [CGFloat],
            let _indices = jsonData["indices"] as? [UInt8]
        else {
            fatalError("Could not build from JSON")
        }
    
        self.init(vertices: _vertices, indices: _indices)
    }
}

class Loader3D {
    
    static func toJSON(_ data: Loader3DObject) -> Data? {
        
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(data) else {
            return nil
        }
        
        return jsonData
    }
}
