//
//  ViewController.swift
//  timeboARd
//
//  Created by Anthony A. Nader on 2017-10-20.
//  Copyright © 2017 Anthony A. Nader. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSKViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let planeNode = createPlaneNode(anchor: planeAnchor)
        
        // ARKit owns the node corresponding to the anchor, so make the plane a child node.
        node.addChildNode(planeNode)
    }

    func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        // Create a SceneKit plane to visualize the node using its position and extent.
        // Create the geometry and its materials
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        let lavaImage = UIImage(named: "Lava")
        let lavaMaterial = SCNMaterial()
        lavaMaterial.diffuse.contents = lavaImage
        lavaMaterial.isDoubleSided = true
        
        plane.materials = [lavaMaterial]
        
        // Create a node with the plane geometry we created
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        // SCNPlanes are vertically oriented in their local coordinate space.
        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        return planeNode
    }
    
//    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
//        // Create and configure a node for the anchor added to the view's session.
//
//
//        let labelNode = SKLabelNode(text: "⭕️")
//        labelNode.horizontalAlignmentMode = .center
//        labelNode.verticalAlignmentMode = .center
//        return labelNode;
//        //print(sceneView.session.currentFrame?.anchors.)
//    }
    
 func createFloorNode(anchor: ARPlaneAnchor) -> SCNNode {
        let floor = SCNFloor()

        let lavaImage = UIImage(named: "Lava")

        let lavaMaterial = SCNMaterial()
        lavaMaterial.diffuse.contents = lavaImage
        lavaMaterial.isDoubleSided = true

        floor.materials = [lavaMaterial]

        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)

        return floorNode
    }
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
