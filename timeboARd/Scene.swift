//
//  Scene.swift
//  timeboARd
//
//  Created by Anthony A. Nader on 2017-10-20.
//  Copyright © 2017 Anthony A. Nader. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    var anchors: [ARAnchor] = []
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        
        // Get the first touch location on screen
        if let touchLocation = touches.first?.location(in: sceneView) {
            
            
            // Create anchor using the camera's current position
            if let currentFrame = sceneView.session.currentFrame {
                
                // Create a transform with a translation of 0.2 meters in front of the camera
                var translation = matrix_identity_float4x4
                translation.columns.3.z = -1
                let transform = simd_mul(currentFrame.camera.transform, translation)
                
                // Add a new anchor to the session
                let anchor = ARAnchor(transform: transform)
                sceneView.session.add(anchor: anchor)
            }
            
        }
    }
}
