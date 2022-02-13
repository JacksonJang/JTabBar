//
//  MainViewController.swift
//  JTabBar_Example
//
//  Created by 장효원 on 2022/02/07.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var data:[String] = [
        "ButtonTabViewController"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as! MainViewCell
        
        cell.titleLabel.text = data[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
        case 0:
            pushViewController(type: ButtonTabViewController.self)
        default:
            print("rest of index")
        }
    }
    
}

extension MainViewController {
    func pushViewController<T>(type:T.Type) {
        if let vc:UIViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: T.self)) {

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class MainViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    
}
