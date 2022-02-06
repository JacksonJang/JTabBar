//
//  ViewController.swift
//  JTabBar
//
//  Created by 장효원 on 02/03/2022.
//  Copyright (c) 2022 장효원. All rights reserved.
//

import UIKit
import JTabBar

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundColors = [getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor()]
        
        let viewControllers = backgroundColors.enumerated().map { (index, elements) -> UIViewController in
            let controller = UIViewController()
            controller.view.backgroundColor = elements
            return controller
        }
        
        let config = createJTabConfig()
        var menus:[String] = []
        
        for index in 0..<viewControllers.count {
            menus.append("Tab\(index)")
        }
        
        //Adding ViewControllers
        JTabBar(viewControllers: viewControllers,menus: menus, config: config).add(parentController: self)
    }
    
    func createJTabConfig() -> JTabConfig {
        let config = JTabConfig()
        
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
