//
//  ButtonTabViewController.swift
//  JTabBar
//
//  Created by 장효원 on 02/03/2022.
//  Copyright (c) 2022 장효원. All rights reserved.
//

import UIKit
import JTabBar

class ButtonTabViewController: UIViewController {

    var viewControllers:[UIViewController] = []
    var tab:JTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundColors = [getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor()]
        
        self.viewControllers = backgroundColors.enumerated().map { (index, elements) -> UIViewController in
            let controller = UIViewController()
            controller.view.backgroundColor = elements
            return controller
        }
        
        let config = createJTabConfig(viewControllers: viewControllers)
        
        //Adding ViewControllers
        createJTabBar(config:config)
        createExampleController()
        updateConstraints()
    }
    
    func createJTabBar(config:JTabConfig) {
        //Adding ViewControllers
        tab = JTabBar(
            viewControllers: viewControllers,
            config: config
        )
        tab.view.translatesAutoresizingMaskIntoConstraints = false
        tab.add(parentController: self)
    }
    
    func createJTabConfig(viewControllers:[UIViewController]) -> JTabConfig {
        var menus:[String] = []
        
        for index in 0..<viewControllers.count {
            menus.append("Tab\(index)")
        }
        
        let config = JTabConfig(menus: menus)
        
        config.menuType = .button
        config.menuHeight = 50.0
        config.menuBottomLineHeight = 3.0
        config.menuBottomLineColor = .black
        
        return config
    }
    
    func createExampleController() {

    }
    
    func updateConstraints() {
        if #available(iOS 11.0, *) {
            tab.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        } else {
            tab.view.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor, constant: 100).isActive = true
        }
        tab.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tab.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tab.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
            
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

}
