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
    var topView:UIView!
    var somethingLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundColors = [getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor(), getRandomColor()]
        
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
        
        menus.append("Tab1111111111111")
        menus.append("Tab2")
        menus.append("Tab33333")
        menus.append("Tab444444444444")
        menus.append("Tab55555")
        menus.append("Tab6")
        
        let config = JTabConfig(menus: menus)
        
        config.menuType = .button
        config.menuHeight = 50.0
        config.menuBottomLineHeight = 3.0
        config.menuBottomLineColor = .black
        
        return config
    }
    
    func createExampleController() {
        topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: Need to add something function view
        somethingLabel = UILabel()
        somethingLabel.translatesAutoresizingMaskIntoConstraints = false
        somethingLabel.text = "Need to add something function view"
        somethingLabel.textColor = UIColor.black
        
        topView.addSubview(somethingLabel)
        self.view.addSubview(topView)
    }
    
    func updateConstraints() {
        if #available(iOS 11.0, *) {
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        } else {
            topView.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor, constant: 0).isActive = true
        }
        topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        somethingLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        somethingLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        
        //JTabBar
        tab.view.topAnchor.constraint(equalTo: self.topView.bottomAnchor).isActive = true
        tab.view.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor).isActive = true
        tab.view.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            tab.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tab.view.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
            
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

}
