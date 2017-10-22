//
//  AAPopUp+Helper.swift
//  AAPopUp
//
//  Created by Engr. Ahsan Ali on 12/29/2016.
//  Copyright (c) 2016 AA-Creations. All rights reserved.
//


// MARK:- AAPopUps
open class AAPopUps<S, V>: AAPopUp {
    open let _storyboard: String?
    open let _id: String
    
    public init(_ storyboard: String? = nil, identifier: String) {
        self._storyboard = storyboard
        self._id = identifier
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


/// AAPopUp options
open class AAPopUpOptions: NSObject {
    
    open var storyboardName: String?
    open var dismissTag: Int?
    open var cornerRadius: CGFloat = 4.0
    open var animationDuration = 0.2
    open var backgroundColor = UIColor.black.withAlphaComponent(0.7)

}



// MARK: - AAPopUp helper
extension AAPopUp {
    
    /// Get view controller from given AAPopUps object
    ///
    /// - Parameter popup: AAPopUps object
    /// - Returns: UIViewController
    func getViewController(_ popup: AAPopUps<String?, String>) -> UIViewController {
        
        var storyboard_id: String!
        if let storyboard = popup._storyboard {
            storyboard_id = storyboard
        }
        else if let storyboard = options.storyboardName {
            storyboard_id = storyboard
        }
        else {
            fatalError("AAPopUp - Invalid Storyboard name. Aborting ...")
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: storyboard_id, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: popup._id)
    }
}
