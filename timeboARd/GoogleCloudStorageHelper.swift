//
//  FirebaseCloudStorageHelper.swift
//  timeboARd
//
//  Created by Hirday Gupta on 21/10/17.
//  Copyright © 2017 Anthony A. Nader. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseStorageHelper {
    let storageRef = Storage.storage().reference()
    
    func uploadImage(filePath: String) -> StorageUploadTask {
        let localFile = URL(string: filePath)!
        let gcsRef = storageRef.child("whiteboards/w_0.jpg")
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
    
}
