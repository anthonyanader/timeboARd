//
//  DemoPopUp.swift
//  AAPopUp
//
//  Created by Muhammad Ahsan on 03/01/2017.
//  Copyright © 2017 AA-Creations. All rights reserved.
//

import UIKit
import AAPopUp
import Firebase
import FirebaseStorage

class DemoPopUp: UIViewController {
    
    @IBOutlet weak var demoLabel: UILabel!
    @IBOutlet weak var demoTextField: UITextField!
    @IBOutlet weak var demoTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        setBorder(demoTextView)
        setBorder(demoTextField)
        
        
    }
    
    let storageRef = Storage.storage().reference()
    func uploadImage(localFile: URL, title: String, description: String) -> StorageUploadTask {
        let cmetadata = [
            "title": title,
            "description": description
        ]
        
        let gcsRef = storageRef.child("whiteboards/w_0.jpg")
        var downloadURL: URL! // pre-declaration for var scoping
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        metadata.customMetadata = cmetadata
        
        
        let uploadTask = gcsRef.putFile(from: localFile, metadata: metadata) { metadata, error in
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
    
    func setBorder(_ view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func demoButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.uploadImage(localFile: getDocumentsDirectory().appendingPathComponent("screenshotCrop.png"), title: (demoTextField.text)!, description: (demoTextView.text)!)
    }
 
    @IBAction func closeAction(_ sender: Any) {
        
        // MARK:- Dismiss action
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}



