//
//  JTabBar.swift
//  JTabBar
//
//  Created by 장효원 on 2022/02/04.
//

import UIKit

open class JTabBar: UIViewController {
    
    private lazy var menuLayout:UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    
    private lazy var menuView:UICollectionView = {
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: menuLayout)
        
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(JTabMenuCell.self, forCellWithReuseIdentifier: "JTabMenuCell")
        
        return view
    }()
    
    private lazy var borderMenuBottomView:UIView = {
        let view = UIView()
        
        view.backgroundColor = .black
        view.frame = CGRect(x: 0,
                            y: config.menuHeight - config.menuBottomLineHeight,
                            width: 50,
                            height: config.menuBottomLineHeight
        )
        
        return view
    }()
    
    private lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        
        sv.isScrollEnabled = true
        sv.isPagingEnabled = true
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.delegate = self
        
        return sv
    }()
    
    private var viewControllers:[UIViewController]!
    private var menus:[String]!
    private var parentController:UIViewController?
    private var config:JTabConfig!
    
    private let deviceWidth = UIScreen.main.bounds.width
    private let deviceHeight = UIScreen.main.bounds.height
    
    private var previousIndex:Int = 0
    private var currentIndex:Int = 0

    //MARK: - initializer
    public init(viewControllers: [UIViewController], config: JTabConfig) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = viewControllers
        self.menus = config.menus
        self.config = config
        
        switch config.menuType {
        case .button:
            setupButtonTab()
        case .variable:
            setupVariableTab()
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func add(parentController: UIViewController) {
        self.parentController = parentController
        
        parentController.addChildViewController(self)
        parentController.view.addSubview(self.view)
        didMove(toParentViewController: parentController)
    }
}

//MARK: - Creating Tab
extension JTabBar {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(viewControllers.count), height: 0)
    }
    
    private func setupButtonTab() {
        self.view.addSubview(menuView)
        self.menuView.addSubview(borderMenuBottomView)
        self.view.addSubview(scrollView)
        
        if #available(iOS 11.0, *) {
            menuView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            menuView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            menuView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true

            scrollView.topAnchor.constraint(equalTo: menuView.bottomAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            menuView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            menuView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            menuView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

            scrollView.topAnchor.constraint(equalTo: menuView.bottomAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
        
        menuView.heightAnchor.constraint(equalToConstant: config.menuHeight).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        menuView.reloadData()
        
        setupContentView()
    }
    
    private func setupContentView(){
        for (index, _) in viewControllers.enumerated() {
            addContentView(index: index)
        }
    }
    
    private func setupVariableTab(){
        
    }
}

//MARK: - Tab Function
extension JTabBar {
    private func moveToTab(index:Int) {
        let indexPath = IndexPath(row: index, section: 0)
        let scrollViewOffset = CGPoint(x: Int(self.scrollView.frame.width) * index, y: 0)
        
        scrollView.setContentOffset(scrollViewOffset, animated: true)
        menuView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        menuView.reloadData()
    }
    
    private func addContentView(index:Int) {
        let vc = viewControllers[index]
        vc.view.tag = index
        
        vc.willMove(toParentViewController: self)
        
        self.addChildViewController(vc)
        
        let x = deviceWidth * CGFloat(index)
        let y = 0.0
        
        vc.view.frame = CGRect(x: x, y: y, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        
        self.scrollView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    private func removeContentView(index:Int) {
        for view in self.scrollView.subviews {
            if view.tag == index {
                view.removeFromSuperview()
            }
        }
    }
}

extension JTabBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTabMenuCell", for: indexPath) as! JTabMenuCell
        
        cell.titleLabel.text = menus[indexPath.row]
        cell.config = self.config

        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        self.currentIndex = index
        moveToTab(index: index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: config.menuHeight)
    }
}

extension JTabBar: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            let currentIndex = Int(round(scrollView.contentOffset.x / deviceWidth))

            self.currentIndex = currentIndex
            
            //It's status that changed index
            if CGFloat(currentIndex) * deviceWidth == scrollView.contentOffset.x {
                moveToTab(index: currentIndex)
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            let x = scrollView.contentOffset.x / UIScreen.main.bounds.width * 50
            let point = CGPoint(x: x, y: config.menuHeight - config.menuBottomLineHeight)
            
            UIView.animate(withDuration: 0.1, animations: {
                self.borderMenuBottomView.frame.origin = point
            }, completion: nil)
        }
    }
}
