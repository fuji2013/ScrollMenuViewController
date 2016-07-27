//
//  ScrollMenuViewParent.swift
//  Demo
//
//  Created by hf on 2016/07/27.
//  Copyright © 2016年 swift-studying.com. All rights reserved.
//

import UIKit

public protocol ScrollMenuViewParent{
    var childPages:[UIViewController]{ get }
    var nextPage:UIViewController?{ get }
    var previousPage:UIViewController?{ get }
    var currentPage:UIViewController{ get }
}
