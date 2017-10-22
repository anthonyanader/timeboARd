//
//  TimeMachineViewController.swift
//  timeboARd
//
//  Created by Anthony A. Nader on 2017-10-21.
//  Copyright © 2017 Anthony A. Nader. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import VBPiledView

class TimeMachineViewController: UIViewController, VBPiledViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet var piledView: VBPiledView!
    
    var urls: [URL] = []
    
    @IBAction func moveUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private var _subViews = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref = ref.child("users").child((user?.uid)!).child("whiteboards")
        var urlSub = 0

        let EXAMPLE_BOARD_URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/infra-mix-183600.appspot.com/o/whiteboards%2Fw_021-Oct-2017-20-22-01.png?alt=media&token=e0e6d6c9-4389-4f8b-b046-4c16a33da5a3")
        self.urls.append(EXAMPLE_BOARD_URL!)
        let EXAMPLE_DATA = try? Data(contentsOf: EXAMPLE_BOARD_URL!)
        let EXAMPLE_IMAGE = UIImage(data: EXAMPLE_DATA!)
        let UIImgViewWB = UIImageView(image: EXAMPLE_IMAGE)
        UIImgViewWB.isUserInteractionEnabled = true
        UIImgViewWB.tag = urlSub
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(TimeMachineViewController.handleTap))
        UIImgViewWB.addGestureRecognizer(tapRecognizer)
        _subViews.append(UIImgViewWB)
        
        urlSub += 1
        
        
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            let url = URL(string: snapshot.value! as! String)
            self.urls.append(url!)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            let UIImgViewWB = UIImageView(image: image)
            UIImgViewWB.isUserInteractionEnabled = true
            UIImgViewWB.tag = urlSub
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(TimeMachineViewController.handleTap))
            UIImgViewWB.addGestureRecognizer(tapRecognizer)
            self._subViews.append(UIImgViewWB)
            urlSub += 1
        })
        
        for v in _subViews{
            v.contentMode = UIViewContentMode.scaleAspectFill
            v.clipsToBounds = true
            v.backgroundColor = UIColor.gray
            view.isUserInteractionEnabled = true
        }
        
        piledView.dataSource = self
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        let data = try? Data(contentsOf: self.urls[(sender.view?.tag)!])
        MasterVC.whiteboardToLoad = UIImage(data: data!)
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Master") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            let defaults = UserDefaults.standard
            defaults.set(1, forKey: "Fb")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func piledView(_ numberOfItemsForPiledView: VBPiledView) -> Int {
        return _subViews.count
    }
    
    func piledView(_ viewForPiledView: VBPiledView, itemAtIndex index: Int) -> UIView {
        return _subViews[index]
    }
    
}
