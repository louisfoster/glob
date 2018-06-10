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
    var morphs: [[CGFloat]]? { get }
}

/*
 
 */
public struct Loader3DObject: Loader3DObjectProtocol, Codable {
    
    var vertices: [CGFloat]?
    var indices: [UInt8]?
    var morphs: [[CGFloat]]?
}

extension Loader3DObject {
    
    // From vectors (eg an already existing scene kit node)
    init(vectors: [SCNVector3], indices _indices: [UInt8], morphs: [[SCNVector3]] = []) {
        
        var _vertices = [CGFloat]()
        
        for vector in vectors {
            
            _vertices.append(CGFloat(vector.x))
            _vertices.append(CGFloat(vector.y))
            _vertices.append(CGFloat(vector.z))
        }
        
        var _morphs = [[CGFloat]]()
        
        if morphs.count > 0 {
            
            for morph in morphs {
                
                var _morph = [CGFloat]()
                
                for vector in morph {
                    
                    _morph.append(CGFloat(vector.x))
                    _morph.append(CGFloat(vector.y))
                    _morph.append(CGFloat(vector.z))
                }
                
                _morphs.append(_morph)
            }
        }
        
        self.init(vertices: _vertices, indices: _indices, morphs: _morphs)
    }
    
    // From JSON
    init(json: Data) {
        
        guard let parseData = try? JSONSerialization.jsonObject(with: json, options: []),
            let jsonData = parseData as? [String: Any],
            let _vertices = jsonData["vertices"] as? [CGFloat],
            let _indices = jsonData["indices"] as? [UInt8],
            let _morphs = jsonData["morphs"] as? [[CGFloat]]
        else {
            
            fatalError("Could not build from JSON")
        }
    
        self.init(vertices: _vertices, indices: _indices, morphs: _morphs)
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
