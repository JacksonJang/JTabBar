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
        
        let viewControllers = backgroundColors.enumerated().map { (index, elements) -> JTabViewController in
            let controller = JTabViewController()
            controller.view.backgroundColor = elements
            controller.tabName = "Tab\(index)"
            return controller
        }
     
        //Adding ViewControllers
        JTabBar(viewControllers: viewControllers).add(parentController: self)
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
            
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

}
