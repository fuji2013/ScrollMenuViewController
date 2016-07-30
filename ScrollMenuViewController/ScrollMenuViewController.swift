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
    
    func swipeInteractionControllerBegan(current:UIViewController, to:UIViewController, next:UIViewController?, previous:UIViewController?){
        
        // toをchildViewとして登録
        addChildViewController(to)
        
        // toが前ページのとき、toを移動
        if to === previous{
            moveToOutside(to.view)
            view.insertSubview(to.view, aboveSubview: current.view)
        }else if to === next{
            // toが次ページのとき、currentを移動
            moveToZeroPosition(to.view)
            view.insertSubview(to.view, belowSubview: current.view)
        }
        to.didMoveToParentViewController(self)
    }
    
    func swipeInteractionControllerChanged(current current: UIViewController, to: UIViewController, next: UIViewController?, previous: UIViewController?) {
        
        // 現在表示中画面の移動
        if to === previous{
            let toPosition = to.view.frame.origin
            let toSize = to.view.frame.size
            let movingPosition = CGPoint(x: (toSize.width * -1) + swipeInteractionController.translation.x, y: toPosition.y)
            to.view.frame = CGRect(origin: movingPosition, size: toSize)
        }else if to === next{
            let movingPosition = CGPoint(x: swipeInteractionController.translation.x, y: current.view.frame.origin.y)
            let currentSize = current.view.frame.size
            current.view.frame = CGRect(origin: movingPosition, size: currentSize)
        }
    }
    
    func swipeInteractionControllerCancelled(current: UIViewController, to: UIViewController, next: UIViewController?, previous: UIViewController?) {
        
        // 現在表示中画面の表示
        if to === previous{
            UIView.animateWithDuration(0.3, animations: {
                self.moveToOutside(to.view)
                }, completion: { (finished) in
                    
                // toをchildViewControllerから削除
                to.willMoveToParentViewController(nil)
                to.view.removeFromSuperview()
                to.removeFromParentViewController()
            })
        }else if to === next{
            UIView.animateWithDuration(0.3, animations: { 
                self.moveToZeroPosition(current.view)
                }, completion: { (finished) in
                    
                // toをchildViewControllerから削除
                to.willMoveToParentViewController(nil)
                to.view.removeFromSuperview()
                to.removeFromParentViewController()
            })
        }
    }
    
    func swipeInteractionControllerCompleted(current: UIViewController, to: UIViewController, next: UIViewController?, previous: UIViewController?) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.moveToZeroPosition(to.view)
            if to === next{
                self.moveToOutside(current.view)
            }
            
            }) { (finished) in
                // currentをchildViewControllerから削除
                current.willMoveToParentViewController(nil)
                current.view.removeFromSuperview()
                current.removeFromParentViewController()
                
                self.currentPage = to
                self.swipeInteractionController.wireToController(to, next: self.nextPage, previous: self.previousPage)
        }
        
        current.transitioningDelegate = nil
        to.transitioningDelegate = self
    }

    private func moveToZeroPosition(view:UIView){
        view.frame = CGRect(origin: CGPointZero, size: view.bounds.size)
    }
    
    private func moveToOutside(view:UIView){
        view.frame = CGRect(x: view.bounds.width * -1, y: view.bounds.origin.y, width: view.bounds.width, height: view.bounds.height)
    }
}
