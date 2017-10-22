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

class TimeMachineViewController: UIViewController, VBPiledViewDataSource {
    @IBOutlet var piledView: VBPiledView!
    
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
        
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            let url = URL(string: snapshot.value! as! String)
            print (url)
            let data = try? Data(contentsOf: url!)
            self._subViews.append(UIImageView(image: UIImage(data: data!)))
        })
        
        for v in _subViews{
            v.contentMode = UIViewContentMode.scaleAspectFill
            v.clipsToBounds = true
            v.backgroundColor = UIColor.gray
        }
        
        piledView.dataSource = self
    }
    
    func piledView(_ numberOfItemsForPiledView: VBPiledView) -> Int {
        return _subViews.count
    }
    
    func piledView(_ viewForPiledView: VBPiledView, itemAtIndex index: Int) -> UIView {
        return _subViews[index]
    }
    
}
