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

protocol Loader3DProtocol {
    var vertices: [CGFloat]? { get set }
    var indices: [UInt8]? { get }
}

struct Loader3D: Loader3DProtocol, Codable {
    var vertices: [CGFloat]?
    var indices: [UInt8]?
}

extension Loader3D {
    // From vectors
    init(vectors: [SCNVector3], indices _indices: [UInt8]) {
        self.indices = _indices
        self.vertices = [CGFloat]()
        for vector in vectors {
            self.vertices?.append(contentsOf: [vector.x, vector.y, vector.z])
        }
    }
    
    // From JSON
    init(json: Data) {
        do {
            let parseData = try JSONSerialization.jsonObject(with: json, options: [])
            if let jsonData = parseData as? [String: Any] {
                guard let _vertices = jsonData["vertices"] as? [CGFloat],
                    let _indices = jsonData["indices"] as? [UInt8]
                else {
                    fatalError("Could not build from JSON")
                }
                
                self.init(vertices: _vertices, indices: _indices)
            }
            else {
                fatalError("Could not build from JSON")
            }
        }
        catch {
            fatalError("Could not build from JSON")
        }
    }
}

extension Loader3D {
    func toJSON() -> Data? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            if let json = String(data: jsonData, encoding: .utf8) {
                print("\(json)")
            }
            return jsonData
        }
        catch {
            print("Could not create json")
            return nil
        }
    }
}
