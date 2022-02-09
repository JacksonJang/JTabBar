//
//  JTabConfig.swift
//  JTabBar
//
//  Created by 장효원 on 2022/02/05.
//

import UIKit


public class JTabConfig {
    open var menuType:MenuType = .button
    
    //Menu Tab
    open var menuTopMargin:CGFloat = 0.0
    open var menuLeftMargin:CGFloat = 0.0
    open var menuRightMargin:CGFloat = 0.0
    open var menuBottomMargin:CGFloat = 0.0
    open var menuHeight:CGFloat = 50.0
    
    //Menu Bottom Line
    open var menuBottomLineHeight:CGFloat = 1.0
    open var menuBottomLineColor:UIColor = UIColor.black
    
    //Menu titles
    open var menus:[String] = []
    
    public init(menus:[String]) {
        self.menus = menus
    }
}
