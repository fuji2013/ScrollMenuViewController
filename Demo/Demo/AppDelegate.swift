//
//  AppDelegate.swift
//  Demo
//
//  Created by hf on 2016/07/09.
//  Copyright © 2016年 swift-studying.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 初期画面の作成
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = createRootViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func createRootViewController() -> UIViewController{
        let scrollMenuViewController = ScrollMenuViewController()
        let child1ViewController = UIViewController()
        let child2ViewController = UIViewController()
        
        scrollMenuViewController.addChildMenuViewController(child1ViewController)
        scrollMenuViewController.addChildMenuViewController(child2ViewController)
        
        return scrollMenuViewController
    }
}
