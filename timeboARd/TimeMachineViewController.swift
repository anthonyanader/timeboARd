//
//  TimeMachineViewController.swift
//  timeboARd
//
//  Created by Anthony A. Nader on 2017-10-21.
//  Copyright © 2017 Anthony A. Nader. All rights reserved.
//

import Foundation
import UIKit
import BeastComponents

class TimeMachineViewController: UIViewController, BCCoverFlowViewDataSource, BCCoverFlowViewDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var coverFlowView: BCCoverFlowView!
    
    var movies = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        
        self.loadMovies()
        
        self.coverFlowView.register(nib: UINib.init(nibName: "MoviePoster", bundle: nil), forCoverReuseIdentifier: "MoviePoster")
        
        self.coverFlowView.gradientColorForStream = .black
        self.coverFlowView.heightOverPassed = 40
        
        self.coverFlowView.dataSource = self
        self.coverFlowView.delegate = self
        self.coverFlowView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMovies() {
        if        let fileUrl = Bundle.main.url(forResource: "Movies", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [[String: Any]] {
                self.movies.append(contentsOf: result!)
            }
        }
    }
    
    func numberOfCovers(in coverFlowView: BCCoverFlowView) -> Int {
        return self.movies.count
    }
    
    func coverFlowView(_ coverFlowView: BCCoverFlowView, contentAt index: Int) -> BCCoverContentView {
        let coverView = self.coverFlowView.dequeueReusableCoverContentView(withIdentifier: "MoviePoster", for: index) as! MoviePoster
        coverView.movie = self.movies[index]
        return coverView
    }
    
    func coverFlowView(_ coverFlowView: BCCoverFlowView, didSelectCoverViewAtIndex index: Int) {
        if let selectedPosterView = self.coverFlowView.coverContentView(for: index) as? MoviePoster {
        }
        
        /*
         // It supports transitions to be presented and dismissed on UIViewControllerTransitioningDelegate, too.
         vc.transitioningDelegate = self
         self.present(vc, animated: true, completion: nil)
         */
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return operation == .push ? self.coverFlowView.presentDetailAnimationController.zoomIn : self.coverFlowView.presentDetailAnimationController.zoomOut
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.coverFlowView.presentDetailAnimationController.zoomInAndFlipRight
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.coverFlowView.presentDetailAnimationController.zoomOutAndFlipLeft
    }

}
