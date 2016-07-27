//
//  ChildMenuViewController.swift
//  ScrollMenuViewController
//
//  Created by hf on 2016/07/10.
//  Copyright © 2016年 swift-studying.com. All rights reserved.
//

import UIKit

class ChildMenuViewController: UIViewController {
    var nextVC: UIViewController?
    var previousVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.redColor()
        
        let button = UIButton(type: .System)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        button.setTitle("タップ", forState: .Normal)
        button.addTarget(self, action: #selector(ChildMenuViewController.showNext), forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }
    
    func showNext(){
        let vc = ChildMenuViewController()
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
}
