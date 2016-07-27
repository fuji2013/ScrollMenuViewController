//
//  LeftToRightAnimator.swift
//  ScrollMenuViewController
//
//  Created by hf on 2016/07/10.
//  Copyright © 2016年 swift-studying.com. All rights reserved.
//

import UIKit

//internal class LeftToRightAnimator:NSObject, UIViewControllerAnimatedTransitioning{
//    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
//        return 1.0
//    }
//    
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
//            toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
//            containerView = transitionContext.containerView() else{
//                return
//        }
//        
//        let finalFrame = transitionContext.finalFrameForViewController(toVC)
//        let initialFrame = CGRect(x: finalFrame.size.width * -1, y: finalFrame.origin.y, width: finalFrame.size.width, height: finalFrame.size.height)
//        toVC.view.frame = initialFrame
//        containerView.addSubview(fromVC.view)
//        containerView.addSubview(toVC.view)
//        
//        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
//            toVC.view.frame = finalFrame
//            
//            }) {
//                finished in
//                let completeFlg = !transitionContext.transitionWasCancelled()
//                transitionContext.completeTransition(completeFlg)
//        }
//    }
//}
