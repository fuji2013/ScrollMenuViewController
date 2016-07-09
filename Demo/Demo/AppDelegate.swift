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
        window?.rootViewController = ScrollMenuViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}
