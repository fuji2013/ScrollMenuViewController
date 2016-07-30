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
protocol SwipeInteractionControllerDelegate: NSObjectProtocol {
    /**
     スワイプ開始時に実行される
    */
    func swipeInteractionControllerBegan(current:UIViewController, to:UIViewController, next:UIViewController?, previous:UIViewController?)
    
    /**
     スワイプ時に随時実行される
    */
    func swipeInteractionControllerChanged(current current:UIViewController, to:UIViewController, next:UIViewController?, previous:UIViewController?)
    
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
    var interactionProgress = false
    var translation = CGPointZero
    var velocity = CGPointZero
    
    
    private var shouldCompleteTransition = false
    private var currentViewController:UIViewController!
    private var targetViewController:UIViewController?
    private var nextViewController:UIViewController?
    private var previousViewController:UIViewController?
    
    override init() {
        super.init()
        completionSpeed = 0.3
    }
    
    func wireToController(current:UIViewController, next:UIViewController?, previous:UIViewController?){
        currentViewController = current
        nextViewController = next
        previousViewController = previous
        
        prepareGestureRecognizerInView(current.view)
    }
    
    private func prepareGestureRecognizerInView(view:UIView){
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.dynamicType.handleGesture))
        view.addGestureRecognizer(gesture)
    }
    
    func handleGesture(gestureRecgnizer:UIPanGestureRecognizer){
        // スワイプでの移動距離
        translation = gestureRecgnizer.translationInView(gestureRecgnizer.view!.superview!)
        
        // スワイプ速度
        velocity = gestureRecgnizer.velocityInView(gestureRecgnizer.view!.superview!)
        
        // 現在表示中画面のサイズ、位置
        let currentViewRect = currentViewController.view.frame
        
        // 現在表示中画面と移動距離を比較した時の移動比率
        let fraction = abs((translation.x / currentViewRect.size.width))
        
        switch gestureRecgnizer.state{
        case .Began:
            
            // スワイプで移動があったときのみ処理を開始
            guard translation.x != 0 else{
                return
            }
            
            // スワイプの方向により、遷移先画面を切替
            // 左スワイプは次画面へ。右スワイプは前画面へ。
            // 次画面や前画面がないときはページ切替処理終了
            guard let targetViewController = translation.x > 0 ? previousViewController : nextViewController else{
                return
            }
            self.targetViewController = targetViewController
            
            // ページ切替処理中に切替
            interactionProgress = true
            
            // スワイプ開始時の処理呼び出し
            delegate?.swipeInteractionControllerBegan(
                currentViewController,
                to: targetViewController,
                next: nextViewController,
                previous: previousViewController)
            
        case .Changed:
            // ページ切替処理中のときのみ、処理を継続する
            guard interactionProgress else{
                return
            }
            
            // スワイプ速度が速いときは即時にページを切り替える
            guard abs(velocity.x) <= 300 else{
                updateInteractiveTransition(1.0)
                
                interactionProgress = false
                shouldCompleteTransition = true
                delegate?.swipeInteractionControllerCompleted(currentViewController, to: targetViewController!, next: nextViewController, previous: previousViewController)
                return
            }
            
            shouldCompleteTransition = fraction > 0.3
            delegate?.swipeInteractionControllerChanged(current: currentViewController, to: targetViewController!, next: nextViewController, previous: previousViewController)
            updateInteractiveTransition(fraction)
            
//            // 現在表示中画面の移動
//            currentViewController.view.frame = CGRect(x: translation.x, y: currentViewRect.origin.y, width: currentViewRect.size.width, height: currentViewRect.size.height)
            
            
            
            
//            if abs(gestureRecgnizer.velocityInView(gestureRecgnizer.view!.superview!).x) > 300{
//                let multiplier:CGFloat = targetViewController === nextViewController ? -1 : 1
//                
//                
//                let diff = NSTimeInterval((self.currentViewController.view.bounds.width - translation.x * multiplier) / self.currentViewController.view.bounds.width)
//                
//                currentViewController.view.removeGestureRecognizer(gestureRecgnizer)
//                UIView.animateWithDuration(diff * 0.5, animations: {
//                    self.currentViewController.view.frame = CGRect(origin: CGPoint(x: self.currentViewController.view.bounds.size.width * multiplier, y:0), size: self.currentViewController.view.bounds.size)
//                    }, completion: { (finished) in
//                        self.delegate?.swipeInteractionControllerCompleted(self.currentViewController, to: self.targetViewController!, next: self.nextViewController, previous: self.previousViewController)
//                        self.finishInteractiveTransition()
//                })
//                interactionProgress = false
//
//            }else{
//            
//                shouldCompleteTransition = fraction > 0.3
//                updateInteractiveTransition(fraction)
//            }
            
        case .Ended, .Cancelled:
            // ページ切替処理中のみ処理を継続
            guard interactionProgress else{
                return
            }
            
            // スワイプキャンセル時、スワイプ完了時の処理呼び出し
            if !shouldCompleteTransition || gestureRecgnizer.state == .Cancelled{
                delegate?.swipeInteractionControllerCancelled(currentViewController, to: targetViewController!, next: nextViewController, previous: previousViewController)
                cancelInteractiveTransition()
            }else{
                delegate?.swipeInteractionControllerCompleted(currentViewController, to: targetViewController!, next: nextViewController, previous: previousViewController)
                finishInteractiveTransition()
            }
            
            // ページ切替処理終了
            interactionProgress = false
            
            
//            currentViewController.view.removeGestureRecognizer(gestureRecgnizer)
            
//            if !shouldCompleteTransition || gestureRecgnizer.state == .Cancelled{
//                let multiplier:CGFloat = targetViewController === nextViewController ? -1 : 1
//                let diff = NSTimeInterval((self.currentViewController.view.bounds.width - translation.x * multiplier) / self.currentViewController.view.bounds.width)
//                
//                UIView.animateWithDuration(diff * 0.5, animations: {
//                    self.currentViewController.view.frame = CGRect(origin: CGPointZero, size: self.currentViewController.view.bounds.size)
//                    }, completion: { (finished) in
//                        
//
//                    self.delegate?.swipeInteractionControllerCancelled(self.currentViewController, to: self.targetViewController!, next: self.nextViewController, previous: self.previousViewController)
//                })
//                self.cancelInteractiveTransition()
//                
//            }else{
//                let multiplier:CGFloat = targetViewController === nextViewController ? -1 : 1
//                
//                
//                let diff = NSTimeInterval((self.currentViewController.view.bounds.width - translation.x * multiplier) / self.currentViewController.view.bounds.width)
//                
//
//                UIView.animateWithDuration(diff * 0.5, animations: {
//                    self.currentViewController.view.frame = CGRect(origin: CGPoint(x: self.currentViewController.view.bounds.size.width * multiplier, y:0), size: self.currentViewController.view.bounds.size)
//                    }, completion: { (finished) in
//                        self.delegate?.swipeInteractionControllerCompleted(self.currentViewController, to: self.targetViewController!, next: self.nextViewController, previous: self.previousViewController)
//                        self.finishInteractiveTransition()
//                })
            
                
            
        default:
            break
        }
    }
}
