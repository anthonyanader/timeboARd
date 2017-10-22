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

        let EXAMPLE_BOARD_URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/infra-mix-183600.appspot.com/o/whiteboards%2Fw_021-Oct-2017-20-22-01.png?alt=media&token=e0e6d6c9-4389-4f8b-b046-4c16a33da5a3")
        let EXAMPLE_DATA = try? Data(contentsOf: EXAMPLE_BOARD_URL!)
        
        _subViews.append(UIImageView(image: UIImage(data: EXAMPLE_DATA!)))
        
        
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            let url = URL(string: snapshot.value! as! String)
            print (url!)
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
