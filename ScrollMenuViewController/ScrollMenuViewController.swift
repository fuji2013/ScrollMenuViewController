//
//  ScrollMenuViewController.swift
//  ScrollMenuViewController
//
//  Created by hf on 2016/07/09.
//  Copyright © 2016年 swift-studying.com. All rights reserved.
//

import UIKit

/**
 ScrollMenuViewController
 */
class ScrollMenuViewController: UIViewController, UIViewControllerTransitioningDelegate {
    private let swipeInteractionController = SwipeInteractionController()
    private var childMenuViewControllers: [UIViewController]?
    let leftToRightAnimator = LeftToRightAnimationController()
    let rightToLeftAnimator = RightToLeftReturnAnimationController()
    
    internal func addChildMenuViewController(viewController: UIViewController){
        if childMenuViewControllers == nil{
            childMenuViewControllers = [UIViewController]()
        }
        childMenuViewControllers!.append(viewController)  // already checked not nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let childMenuViewControllers = childMenuViewControllers where !childMenuViewControllers.isEmpty{
            let childVC = childMenuViewControllers.first!
            addChildMenuViewController(childVC)
            addChildViewController(childVC)
            view.addSubview(childVC.view)
            childVC.didMoveToParentViewController(self)
            swipeInteractionController.wireToViewController(childVC, next: childMenuViewControllers.last!)
            childVC.transitioningDelegate = self
        }
    }
    
    internal func getChileMenuViewControllers() -> [UIViewController]?{
        return childMenuViewControllers
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return swipeInteractionController.interactionProgress ? swipeInteractionController : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return swipeInteractionController.interactionProgress ? swipeInteractionController : nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        swipeInteractionController.wireToViewController(presented, next: childMenuViewControllers!.last!)
        return leftToRightAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        swipeInteractionController.wireToViewController(dismissed, next: childMenuViewControllers!.last!)
        return rightToLeftAnimator
    }
}
