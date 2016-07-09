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
class ScrollMenuViewController: UIViewController {
    private var childMenuViewControllers: [UIViewController]?
    
    internal func addChildMenuViewController(viewController: UIViewController){
        if childMenuViewControllers == nil{
            childMenuViewControllers = [UIViewController]()
        }
        childMenuViewControllers!.append(viewController)  // already checked not nil
    }
    
    internal func getChileMenuViewControllers() -> [UIViewController]?{
        return childMenuViewControllers
    }
}
