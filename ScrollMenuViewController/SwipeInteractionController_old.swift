//
//  InteractionController.swift
//  ScrollMenuViewController
//
//  Created by hf on 2016/07/10.
//  Copyright © 2016年 swift-studying.com. All rights reserved.
//

import UIKit

//class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
//    private var shouldCompleteTransition = false
//    private var scrollMenuViewController: UIViewController!
//    private var interactingViewController: UIViewController!
//    private var nextViewController: UIViewController!
//    var interactionInProgress = false
//    var completionInSeed: CGFloat{
//        return 1 - percentComplete
//    }
//    
//    func wireToViewController(viewController: UIViewController, next: UIViewController){
//        scrollMenuViewController = viewController.parentViewController!
//        interactingViewController = viewController
//        nextViewController = next
//        prepareGestureRecognizerInView(viewController.view)
//    }
//    
//    private func prepareGestureRecognizerInView(view: UIView){
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(SwipeInteractionController.handleGesture(_:)))
//        view.addGestureRecognizer(gesture)
//    }
//    
//    func handleGesture(gestureRecognizer: UIPanGestureRecognizer){
//        let translation = gestureRecognizer.translationInView(gestureRecognizer.view!.superview!)
//        
//        switch gestureRecognizer.state {
//        case .Began:
//            interactionInProgress = true
//            interactingViewController.willMoveToParentViewController(nil)
//        case .Changed:
//            var fraction = (translation.x / 200.0)
//            fraction = CGFloat(fminf((fmaxf(Float(fraction), 0.0)), 1.0))
//            shouldCompleteTransition = fraction > 0.5
//            updateInteractiveTransition(fraction)
//        case .Ended:
//            interactionInProgress = false
//            if !shouldCompleteTransition || gestureRecognizer.state == .Cancelled{
//                interactingViewController.didMoveToParentViewController(scrollMenuViewController)
//                cancelInteractiveTransition()
//            }else{
//                interactingViewController.view.removeFromSuperview()
//                interactingViewController.removeFromParentViewController()
//                finishInteractiveTransition()
//            }
//        default:
//            break
//        }
//    }
//}
