//
//  MasterVC.swift
//  timeboARd
//
//  Created by Pradyumn Nukala on 10/21/17.
//  Copyright © 2017 Anthony A. Nader. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Firebase
import FirebaseStorage
import PKCCrop
import AAPopUp

class MasterVC: UIViewController, ARSCNViewDelegate, PKCCropDelegate {
    
    // Crop Delegate
    func pkcCropCancel(_ viewController: PKCCropViewController) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    func pkcCropImage(_ image: UIImage?, originalImage: UIImage?) {
        if let data = UIImagePNGRepresentation(image!) {
            let filename = getDocumentsDirectory().appendingPathComponent("screenshotCrop.png")
            try? data.write(to: filename)
        }
        let popup: AAPopUp = AAPopUp(popup: .demo2)
        
        let label = popup.viewWithTag(10) as! UILabel
        label.text = "Welcome to AAPopUp!"
        popup.present { popup in
            
            // MARK:- View Did Appear Here
            
            popup.dismissWithTag(9)
            
            
        }
    }
    
    func pkcCropComplete(_ viewController: PKCCropViewController) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // Non - Picker Delegate
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var gestureRegionView: UIView!
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    var planeNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.becomeFirstResponder() // To get shake gesture
        
        let swipeUpGC = UISwipeGestureRecognizer(target: self, action: #selector(MasterVC.didSwipeUp))
        swipeUpGC.direction = UISwipeGestureRecognizerDirection.up
        gestureRegionView.addGestureRecognizer(swipeUpGC)
        
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if dotNodes.count > 2 {
                sceneView.session.pause()
            }else{
                if let hitResult = hitTestResults.first {
                    addDot(at: hitResult)
                }
            }
        }
    }
    
    func addDot(at hitResult : ARHitTestResult) {
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate (){
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        print(start.position)
        print(end.position)
        
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
                pow(end.position.y - start.position.y, 2) +
                pow(end.position.z - start.position.z, 2)
        )
        updatePlane(begPosition: start.position, endPosition: end.position)
        //updateText(text: "\(abs(distance))", atPosition: end.position)
        
        //        distance = √ ((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
        
    }
    
    func updatePlane(begPosition positionA: SCNVector3,endPosition positionB: SCNVector3){
        
        planeNode.removeFromParentNode()
        let X = positionB.x - positionA.x
        let posX = CGFloat(X)
        let Y = positionB.y - positionA.y
        let posY = CGFloat(Y)
        print(posX)
        print(posY)
        let planeGeometry = SCNPlane(width: posX, height: posY)
        
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/infra-mix-183600.appspot.com/o/whiteboards%2Fw_021-Oct-2017-20-22-01.png?alt=media&token=e0e6d6c9-4389-4f8b-b046-4c16a33da5a3")
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        let theImage = UIImage(data: data!)
        let flippedImage = theImage?.imageFlippedForRightToLeftLayoutDirection()
        planeGeometry.firstMaterial?.diffuse.contents = flippedImage
        
        planeNode = SCNNode(geometry: planeGeometry)
        
        planeNode.position = SCNVector3(positionA.x, positionA.y , positionA.z)
        //planeNode.eulerAngles.z = 0
        //planeNode.eulerAngles.y = 0
        //planeNode.eulerAngles.x = 0
        
        planeNode.pivot = SCNMatrix4MakeTranslation(0.125, 0.125, 0)
        
        sceneView.scene.rootNode.addChildNode(planeNode)
    }
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Why are you shaking me?")
            sceneView.session.run(sceneView.session.configuration!, options: .removeExistingAnchors)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    @IBAction func takePhoto() {
        let ciImage = CIImage(cvPixelBuffer: (sceneView.session.currentFrame?.capturedImage)!)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        let image = UIImage(cgImage: cgImage!)
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent("screenshot.png")
            try? data.write(to: filename)
        }
        
        PKCCropHelper.shared.degressBeforeImage = UIImage(named: "pkc_crop_rotate_left.png")
        PKCCropHelper.shared.degressAfterImage = UIImage(named: "pkc_crop_rotate_right.png")
        PKCCropHelper.shared.isNavigationBarShow = false
        let cropVC = PKCCrop().cropViewController(image)
        cropVC.delegate = self
        self.present(cropVC, animated: true, completion: nil)
        
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func uploadImage(localFile: URL) -> StorageUploadTask {
        let storageRef = Storage.storage().reference()
        let gcsRef = storageRef.child("whiteboards/w_0" + self.currDateInString() + ".png")
        var downloadURL: URL! // pre-declaration for var scoping
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        
        let uploadTask = gcsRef.putFile(from: localFile, metadata: nil) { metadata, error in
            if let error = error {
                // TODO: Handle error.
                print (error)
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                downloadURL = metadata!.downloadURL()
            }
        }
        
        return uploadTask // documentation of uploadTask object: https://firebase.google.com/docs/storage/ios/upload-files
    }
    
    func currDateInString() -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date())
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy-HH-mm-ss"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    @objc func didSwipeUp() {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TimeMachineRoot") {
            
            self.present(viewController, animated: true, completion: nil)
        }
    }

}













