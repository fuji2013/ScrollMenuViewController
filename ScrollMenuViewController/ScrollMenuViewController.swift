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
class ScrollMenuViewController: UIViewController, UIViewControllerTransitioningDelegate, ScrollMenuViewParent, SwipeInteractionControllerDelegate {
    private let swipeInteractionController = SwipeInteractionController()
    private var childMenuViewControllers: [UIViewController]?
    private var current: UIViewController?
    let leftToRightAnimator = LeftToRightAnimationController()
    let rightToLeftAnimator = RightToLeftReturnAnimationController()
    
    func addChildPageViewController(viewControler: UIViewController){
        if childMenuViewControllers == nil{
            current = viewControler
            viewControler.transitioningDelegate = self
            childMenuViewControllers = [UIViewController]()
        }
        childMenuViewControllers!.append(viewControler)  // already checked not nil
    }
    

    
    var previousPage: UIViewController?{
        guard let childPages = self.childMenuViewControllers else{
            return nil
        }
        
        guard let current = self.currentPage else{
            return nil
        }
        
        guard let currentIndex = childPages.indexOf(current) else{
            return nil
        }
        
        if currentIndex > 0{
            return childPages[currentIndex - 1]
        }
        return nil
    }
    
    var currentPage: UIViewController?{
        set(new){
            current = new
        }
        get{
            return current
        }
    }
    
    var nextPage: UIViewController?{

        guard let childPages = self.childMenuViewControllers else{
            return nil
        }
        
        guard let current = self.currentPage else{
            return nil
        }
        
        guard let currentIndex = childPages.indexOf(current) else{
            return nil
        }
        
        if currentIndex < childPages.count - 1{
            return childPages[currentIndex + 1]
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let childMenuViewControllers = childMenuViewControllers where !childMenuViewControllers.isEmpty{
            let childVC = childMenuViewControllers.first!
            addChildViewController(childVC)
            view.addSubview(childVC.view)
            childVC.didMoveToParentViewController(self)
            swipeInteractionController.wireToController(current!, next: nextPage!, previous: nil)
            swipeInteractionController.delegate = self
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
    
    func swipeInteractionControllerBegan(current: UIViewController, toViewController: UIViewController) {
        addChildViewController(toViewController)
        moveToZeroPosition(toViewController.view)
        view.insertSubview(toViewController.view, belowSubview: current.view)
        toViewController.didMoveToParentViewController(self)
    }

    func swipeInteractionControllerCancelled(current: UIViewController, next: UIViewController?, previous: UIViewController?, cancelled: UIViewController) {
        cancelled.willMoveToParentViewController(nil)
        cancelled.view.removeFromSuperview()
        cancelled.removeFromParentViewController()
    }

    func swipeInteractionControllerCompleted(current: UIViewController, next: UIViewController?, previous: UIViewController?, after: UIViewController) {

        current.willMoveToParentViewController(nil)
        current.view.removeFromSuperview()
        current.removeFromParentViewController()
        
        current.transitioningDelegate = nil
        after.transitioningDelegate = self
        
        currentPage = after
        swipeInteractionController.wireToController(currentPage!, next: nextPage, previous: previousPage)
    }
    
    private func moveToZeroPosition(view:UIView){
        view.frame = CGRect(origin: CGPointZero, size: view.bounds.size)
    }
}
