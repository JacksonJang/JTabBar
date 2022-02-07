//
//  VariableTabViewController.swift
//  JTabBar_Example
//
//  Created by 장효원 on 2022/02/07.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import JTabBar

class VariableTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundColors = [getRandomColor(), getRandomColor()]
        
        let viewControllers = backgroundColors.enumerated().map { (index, elements) -> UIViewController in
            let controller = UIViewController()
            controller.view.backgroundColor = elements
            return controller
        }
        
        let config = createJTabConfig(viewControllers: viewControllers)
        
        //Adding ViewControllers
        JTabBar(viewControllers: viewControllers,
                config: config
        ).add(parentController: self)
    }
    
    func createJTabConfig(viewControllers:[UIViewController]) -> JTabConfig {
        var menus:[String] = []
        
        for index in 0..<viewControllers.count {
            menus.append("Tab\(index)")
        }
        
        let config = JTabConfig(menus: menus)
        
        config.menuType = .variable
        config.menuHeight = 50.0
        config.menuBottomLineHeight = 3.0
        config.menuBottomLineColor = .black
        
        return config
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
            
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
