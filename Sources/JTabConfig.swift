//
//  JTabConfig.swift
//  JTabBar
//
//  Created by 장효원 on 2022/02/05.
//

import UIKit


public class JTabConfig {
    open var menuType:MenuType = .button
    open var menuHeight:CGFloat = 50.0
    open var menuBottomLineHeight:CGFloat = 1.0
    open var menuBottomLineColor:UIColor = UIColor.black
    open var menus:[String] = []
    
    public init(menus:[String]) {
        self.menus = menus
    }
}
