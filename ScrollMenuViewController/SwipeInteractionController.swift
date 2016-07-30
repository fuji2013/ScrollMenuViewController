//
//  SwipeInteractionController.swift
//  WebImageCollector
//
//  Created by fuji2013 on 2015/01/23.
//  Copyright (c) 2015年 fuji2013. All rights reserved.
//

import UIKit

/**
 スワイプでのページ切替時の処理インターフェイス
 */
protocol SwipeInteractionControllerDelegate:NSObjectProtocol {
    /**
     スワイプ開始時に実行される
    */
    func swipeInteractionControllerBegan(current:UIViewController, to:UIViewController, next:UIViewController?, previous:UIViewController?)
    
    /**
     スワイプ時に随時実行される
    */
    func swipeInteractionControllerChanged(current:UIViewController, to:UIViewController, next:UIViewController?, previous:UIViewController?)
    
    /**
     スワイプでのページ切替が完了したときに実行される
    */
    func swipeInteractionControllerCompleted(current:UIViewController, to:UIViewController, next:UIViewController?, previous:UIViewController?)
    
    /**
     スワイプでのページ切替が完了した時に実行される
    */
    func swipeInteractionControllerCancelled(current:UIViewController, to:UIViewController, next:UIViewController?, previous:UIViewController?)
}

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    weak var delegate:SwipeInteractionControllerDelegate?
    
    private var shouldCompleteTransition = false
    
    private var currentViewController:UIViewController!
    private var targetViewController:UIViewController?
    private var nextViewController:UIViewController?
    private var previousViewController:UIViewController?
    
    var interactionProgress = false
    
    func wireToController(current:UIViewController, next:UIViewController?, previous:UIViewController?){
        currentViewController = current
        nextViewController = next
        previousViewController = previous
        
        prepareGestureRecognizerInView(current.view)
    }
    
    private func prepareGestureRecognizerInView(view:UIView){
        let gesture = UIPanGestureRecognizer(target: self, action: "handleGesture:")
        view.addGestureRecognizer(gesture)
    }
    
    func handleGesture(gestureRecgnizer:UIPanGestureRecognizer){
        let translation = gestureRecgnizer.translationInView(gestureRecgnizer.view!.superview!)
        
        switch gestureRecgnizer.state{
            
        case .Began:
            // 左にスワイプ(次ページ)
            // 次のVCの表示
            
            guard translation.x != 0 else{
                return
            }
            
            self.targetViewController = translation.x > 0 ? previousViewController : nextViewController
            guard let targetViewController = self.targetViewController else{
                return
            }
            
            delegate?.swipeInteractionControllerBegan(currentViewController, to: targetViewController, next: nextViewController, previous: previousViewController)
            interactionProgress = true
        case .Changed:
            guard interactionProgress else{
                return
            }
            
            let viewRect = currentViewController.view.bounds
            let fraction = abs((translation.x / viewRect.size.width))
            currentViewController.view.frame = CGRect(x: translation.x, y: viewRect.origin.y, width: viewRect.size.width, height: viewRect.size.height)
            
            if abs(gestureRecgnizer.velocityInView(gestureRecgnizer.view!.superview!).x) > 300{
                let multiplier:CGFloat = targetViewController === nextViewController ? -1 : 1
                
                
                let diff = NSTimeInterval((self.currentViewController.view.bounds.width - translation.x * multiplier) / self.currentViewController.view.bounds.width)
                
                currentViewController.view.removeGestureRecognizer(gestureRecgnizer)
                UIView.animateWithDuration(diff * 0.5, animations: {
                    self.currentViewController.view.frame = CGRect(origin: CGPoint(x: self.currentViewController.view.bounds.size.width * multiplier, y:0), size: self.currentViewController.view.bounds.size)
                    }, completion: { (finished) in
                        self.delegate?.swipeInteractionControllerCompleted(self.currentViewController, to: self.targetViewController!, next: self.nextViewController, previous: self.previousViewController)
                        self.finishInteractiveTransition()
                })
                interactionProgress = false

            }else{
            
                shouldCompleteTransition = fraction > 0.3
                updateInteractiveTransition(fraction)
            }
            
            
        case .Ended, .Cancelled:
            guard interactionProgress else{
                return
            }
            
            interactionProgress = false
            currentViewController.view.removeGestureRecognizer(gestureRecgnizer)
            
            if !shouldCompleteTransition || gestureRecgnizer.state == .Cancelled{
                let multiplier:CGFloat = targetViewController === nextViewController ? -1 : 1
                let diff = NSTimeInterval((self.currentViewController.view.bounds.width - translation.x * multiplier) / self.currentViewController.view.bounds.width)
                
                UIView.animateWithDuration(diff * 0.5, animations: {
                    self.currentViewController.view.frame = CGRect(origin: CGPointZero, size: self.currentViewController.view.bounds.size)
                    }, completion: { (finished) in
                        

                    self.delegate?.swipeInteractionControllerCancelled(self.currentViewController, to: self.targetViewController!, next: self.nextViewController, previous: self.previousViewController)
                })
                self.cancelInteractiveTransition()
                
            }else{
                let multiplier:CGFloat = targetViewController === nextViewController ? -1 : 1
                
                
                let diff = NSTimeInterval((self.currentViewController.view.bounds.width - translation.x * multiplier) / self.currentViewController.view.bounds.width)
                

                UIView.animateWithDuration(diff * 0.5, animations: {
                    self.currentViewController.view.frame = CGRect(origin: CGPoint(x: self.currentViewController.view.bounds.size.width * multiplier, y:0), size: self.currentViewController.view.bounds.size)
                    }, completion: { (finished) in
                        self.delegate?.swipeInteractionControllerCompleted(self.currentViewController, to: self.targetViewController!, next: self.nextViewController, previous: self.previousViewController)
                        self.finishInteractiveTransition()
                })
                
                
                
                
            }
        default:
            break
        }
    }
    
}
