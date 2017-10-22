//
//  TimeMachineViewController.swift
//  timeboARd
//
//  Created by Anthony A. Nader on 2017-10-21.
//  Copyright © 2017 Anthony A. Nader. All rights reserved.
//

import Foundation
import UIKit
import VBPiledView

class TimeMachineViewController: UIViewController, VBPiledViewDataSource {
    @IBOutlet var piledView: VBPiledView!
    
    @IBAction func moveUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private var _subViews = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Hirday Modify this to download the MetaData and Image for respective whiteboards.
        _subViews.append(UIImageView(image: #imageLiteral(resourceName: "Camera")))
        _subViews.append(UIImageView(image: #imageLiteral(resourceName: "Settings")))
        _subViews.append(UIImageView(image: #imageLiteral(resourceName: "Collab")))
        _subViews.append(UIImageView(image: UIImage(named: "libertystate.jpg")))
        _subViews.append(UIImageView(image: UIImage(named: "Moonrise.jpg")))
        _subViews.append(UIImageView(image: UIImage(named: "photographer.jpg")))
        
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
