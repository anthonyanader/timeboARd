//
//  AAPopUp.swift
//  AAPopUp
//
//  Created by Engr. Ahsan Ali on 12/29/2016.
//  Copyright (c) 2016 AA-Creations. All rights reserved.
//

import UIKit

open class AAPopUp: UIViewController {
    
    /// Global options
    open static var globalOptions = AAPopUpOptions()
    
    /// Local options
    var options: AAPopUpOptions!

    /// Popup View controller
    var viewController: UIViewController!
    
    /// Keyboard visibility flag
    var keyboardIsVisible = false
    
    /// Init with AAPopUps object with options
    ///
    /// - Parameters:
    ///   - popup: AAPopUps object
    ///   - options: AAPopUpOptions (optional)
    public convenience init(popup: AAPopUps<String?, String>,
                            withOptions options: AAPopUpOptions? = nil) {
        
        self.init()
        
        self.viewController = getViewController(popup)
        initOptions(options)
        
        initPopUp()
        
    }
    
    /// Init with UIViewController of AAPopUp with options
    ///
    /// - Parameters:
    ///   - popup: UIViewController of popup
    ///   - options: AAPopUpOptions (optional)
    public convenience init(popup: UIViewController,
                            withOptions options: AAPopUpOptions? = nil) {
        self.init()
        self.viewController = popup
        
        initOptions(options)
        initPopUp()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    /// Popup did load
    override open func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    
    }
    
    /// Popup did appear
    ///
    /// - Parameter animated: flag
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentPopUpView()
        dismissWithTag(options.dismissTag)
        
    }
    
    /// layout subviews
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.viewController.view.center = self.view.center
        self.viewController.view!.layoutIfNeeded()
        self.view!.setNeedsLayout()
        
    }

    /// init with options if available
    ///
    /// - Parameter options: options object AAPopUpOptions
    func initOptions(_ options: AAPopUpOptions?) {
        if let option = options {
            self.options = option
        }
        else {
            self.options = AAPopUp.globalOptions
        }
    }
    
    
    /// Create Popupup view
    func initPopUp() {
        
        let contentView = viewController.view.subviews.first!.bounds
        viewController.view.bounds = contentView
        
        guard !contentView.isEmpty else {
            fatalError("AAPopUp - All child views must be encapsulate in a single UIView instace. Aborting ...")
        }
        
        if #available(iOS 9.0, *) {
            self.loadViewIfNeeded()
        }
        
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = view.bounds.size
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.bindWithBounds()
        
        
        let scrollContentView = UIView(frame: scrollView.bounds)
        scrollView.addSubview(scrollContentView)
        
        self.addChildViewController(viewController)
        scrollContentView.addSubview(viewController.view!)
        viewController.didMove(toParentViewController: self)
        
        modalPresentationStyle = .overFullScreen
        viewController.view.layer.cornerRadius = options.cornerRadius
        viewController.view.layer.masksToBounds = true
        
        togglePopup() // First Invisible Animaiton
    }
    

    
    /// toggle the popup
    ///
    /// - Parameter show: flag for show
    func togglePopup(_ show: Bool = false) {

        var alpha: CGFloat = 1.0
        var backgroundColor: UIColor = options.backgroundColor
        var transform: CGAffineTransform = .identity
        
        if !show {
            alpha = 0.0
            backgroundColor = backgroundColor.withAlphaComponent(0.0)
            transform = transform.scaledBy(x: 0.6, y: 0.6)
        }
        
        self.viewController.view.alpha = alpha
        self.view.backgroundColor = backgroundColor
        self.viewController.view.transform = transform
        
    }
    


}


//MARK:- public functions

extension AAPopUp {
    
    /// get view with tag in popup
    ///
    /// - Parameter tag: tag for a view
    /// - Returns: UIView object
    open func viewWithTag(_ tag: Int) -> UIView? {
        return view.viewWithTag(tag)
    }
    
    /// dismiss popup with tag
    ///
    /// - Parameter tag: tag
    open func dismissWithTag(_ tag: Int?) {
        if let dismissTag = tag {
            if let button = view.viewWithTag(dismissTag) as? UIButton {
                button.addTarget(self, action:#selector(AAPopUp.dismissPopup), for: .touchUpInside)
            }
        }
    }
    
    /// dismiss popup selector
    @objc func dismissPopup() {
        dismissPopUpView()
    }

    /// present popup with completion
    ///
    /// - Parameter completion: view did load closure
    open func present(completion: ((_ popup: AAPopUp) -> ())?) {
        
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("AAPopUp - Application key window not found. Please check UIWindow in AppDelegate.")
        }
        
        root.present(self, animated: false, completion: {
            completion?(self)
        })
        
    }
    
    /// present popup view with animation
    func presentPopUpView() {
        UIView.animate(withDuration: options.animationDuration, delay: 0, animations: {() -> Void in
            self.togglePopup(true)
        }, completion: nil)
    }
    
    
    
    /// Dismiss popup with animation
    ///
    /// - Parameter completion: completion closure
    open func dismissPopUpView(completion: (() -> ())? = nil) {
        UIView.animate(withDuration: options.animationDuration, animations: {() -> Void in
            self.togglePopup()
        }, completion: {(finished: Bool) -> Void in
            
            self.presentingViewController!.dismiss(animated: false, completion: completion)
            
        })
    }
    
    
}
