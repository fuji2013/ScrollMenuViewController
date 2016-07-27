//
//  SwipeInteractionController.swift
//  WebImageCollector
//
//  Created by fuji2013 on 2015/01/23.
//  Copyright (c) 2015年 fuji2013. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    private var shouldCompleteTransition = false
    private var viewController:UIViewController!
    private var nextViewController:UIViewController?
    var interactionProgress = false
    var completionSeed: CGFloat{
        return 1 - percentComplete
    }
    
    func wireToViewController(viewController:UIViewController, next:UIViewController){
        self.viewController = viewController
        nextViewController = next
        prepareGestureRecognizerInView(viewController.view)
    }
    
    private func prepareGestureRecognizerInView(view:UIView){
        let gesture = UIPanGestureRecognizer(target: self, action: "handleGesture:")
        view.addGestureRecognizer(gesture)
    }
    
    func handleGesture(gestureRecgnizer:UIPanGestureRecognizer){
        let translation = gestureRecgnizer.translationInView(gestureRecgnizer.view!.superview!)
        
        switch gestureRecgnizer.state{
            
        case .Began:
            // 次のVCの表示
            guard let next = nextViewController else{
                return
            }
            
            viewController.parentViewController?.addChildViewController(next)
            viewController.parentViewController?.view.insertSubview(next.view, belowSubview: viewController.view)
            
            interactionProgress = true
            
        case .Changed:
            
            let viewRect = self.viewController.view.bounds
            var fraction = (translation.x / viewRect.size.width)
            self.viewController.view.frame = CGRect(x: translation.x, y: viewRect.origin.y, width: viewRect.size.width, height: viewRect.size.height)
            
            shouldCompleteTransition = fraction > 0.5
            
            updateInteractiveTransition(fraction)
            
        case .Ended, .Cancelled:
            interactionProgress = false
            if !shouldCompleteTransition || gestureRecgnizer.state == .Cancelled{
                self.viewController.view.frame = CGRect(origin: CGPointZero, size: self.viewController.view.bounds.size)
                
                nextViewController?.willMoveToParentViewController(nil)
                nextViewController?.view.removeFromSuperview()
                nextViewController?.removeFromParentViewController()
                
                cancelInteractiveTransition()
            }else{
                self.viewController.view.frame = CGRect(origin: CGPoint(x: self.viewController.view.bounds.size.width * -1, y:0), size: self.viewController.view.bounds.size)
                
                viewController.willMoveToParentViewController(nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParentViewController()
                
                finishInteractiveTransition()
            }
        default:
            break
        }
    }
    
}
