//
//  ShareAndCollaborateViewController.swift
//  timeboARd
//
//  Created by Anthony A. Nader on 2017-10-21.
//  Copyright © 2017 Anthony A. Nader. All rights reserved.
//

import Foundation
import UIKit
import ViewAnimator

class VShareAndCollaborateViewController: UIViewController {
    
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var tableView: UITableView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView.dataSource = self
            
            tableView.tableFooterView = UIView()
            tableView.dataSource = self
        }
    
        @IBAction func animate() {
            view.animateRandom()
            
            // Combined animations example
            //        let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
            //        let zoomAnimation = AnimationType.zoom(scale: 0.2)
            //        let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
            //        collectionView.animateViews(animations: [zoomAnimation, rotateAnimation], duration: 0.5)
            //        tableView.animateViews(animations: [fromAnimation, zoomAnimation], duration: 0.5)
        }
    }

    extension ViewController: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
            cell.userImageView.image = UIImage(named: "\(indexPath.row)")
            return cell
        }
    }

    extension ViewController: UICollectionViewDataSource {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 5
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            cell.backgroundColor = UIColor.red
            cell.layer.cornerRadius = 5.0
            cell.imageView.image = UIImage(named: "\(indexPath.item)")
            return cell
    }
}
