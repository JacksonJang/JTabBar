//
//  JTabMenuCell.swift
//  JTabBar
//
//  Created by 장효원 on 2022/02/04.
//

import UIKit

class JTabMenuCell: UICollectionViewCell {
    let titleLabel:UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.contentView.addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

