//
//  JTabBar.swift
//  JTabBar
//
//  Created by 장효원 on 2022/02/04.
//

import UIKit

open class JTabBar: UIViewController {
    
    lazy var menuLayout:UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    
    lazy var menuView:UICollectionView = {
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: menuLayout)
        
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(JTabMenuCell.self, forCellWithReuseIdentifier: "JTabMenuCell")
        
        return view
    }()
    
    var scrollView:UIScrollView = {
        let sv = UIScrollView()
        
        sv.isScrollEnabled = false
        sv.isPagingEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    var viewControllers:[UIViewController] = []
    var parentController:UIViewController?
    
    var menuHeight:CGFloat = 50.0
    
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    
    var previousIndex:Int = 0
    var currentIndex:Int = 0
    
    //MARK: - initializer
    public init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = viewControllers
        
        setupMenu()
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
    func setupMenu() {
        
        self.view.addSubview(menuView)
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
        
        menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        menuView.reloadData()
    }
}

//MARK: - Tab Function
extension JTabBar {
    
    func moveToTab(index:Int) {
        //remove and save previous index
        removeContentView(index: previousIndex)
        previousIndex = index
        
        addContentView(index: index)
    }
    
    func addContentView(index:Int) {
        let vc = viewControllers[index]
        vc.view.tag = index
        
        vc.willMove(toParentViewController: self)
        
        self.addChildViewController(vc)
        self.scrollView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    func removeContentView(index:Int) {
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
        
        let vc = self.viewControllers[indexPath.row] as! JTabViewController
        cell.titleLabel.text = vc.tabName
        
        if indexPath.row == self.currentIndex {
            cell.addBottomLineView()
        } else {
            cell.removeBottomLineView()
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        self.currentIndex = index
        moveToTab(index: index)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 50, height: menuHeight)
    }
    
}
