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
    
    let bottomLineView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var bottomLineHeight:CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.contentView.addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func addBottomLineView() {
        self.contentView.addSubview(bottomLineView)
        
        bottomLineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        bottomLineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        bottomLineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        bottomLineView.heightAnchor.constraint(equalToConstant: bottomLineHeight).isActive = true
    }
    
    func removeBottomLineView() {
        bottomLineView.removeFromSuperview()
        for constraint in bottomLineView.constraints {
            bottomLineView.removeConstraint(constraint)
        }
    }
}

