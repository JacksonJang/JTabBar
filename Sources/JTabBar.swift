//
//  JTabBar.swift
//  JTabBar
//
//  Created by 장효원 on 2022/02/04.
//

import UIKit

open class JTabBar: UIViewController {
    
    public var menuBottomLineAnimationDuration:CGFloat = 0.3
    public var menuViewAnimationDuration:CGFloat = 0.3
    public var scrollViewAnimationDuration:CGFloat = 0.3
    
    private var viewControllers:[UIViewController]!
    private var menus:[String]!
    private var parentController:UIViewController?
    private var config:JTabConfig!
    
    private var menuViewContentWidthList:[CGFloat] = []
    private var menuViewContentWidth:CGFloat = 0.0
    
    private var previousIndex:Int = 0
    private var currentIndex:Int = 0
    
    //MARK: - ButtonTab Properties
    open var pageWidth: CGFloat {
        return scrollView.frame.width
    }
    
    open func getIndexPageFor(contentOffset: CGFloat) -> Int {
        return Int((contentOffset + 1.5 * pageWidth) / pageWidth) - 1
    }
    
    open var swipeDirection: SwipeDirection {
        if scrollView.contentOffset.x > lastContentOffset {
            return .left
        } else if scrollView.contentOffset.x < lastContentOffset {
            return .right
        }
        return .none
    }
    
    private var lastContentOffset: CGFloat = 0.0

    //MARK: - initializer
    public init(viewControllers: [UIViewController], config: JTabConfig) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = viewControllers
        self.menus = config.menus
        self.config = config
        
        setupButtonTab()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func add(parentController: UIViewController) {
        self.parentController = parentController
        
        parentController.addChild(self)
        parentController.view.addSubview(self.view)
        didMove(toParent: parentController)
    }
    
    private lazy var menuLayout:UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
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
        
        view.backgroundColor = config.menuBottomLineColor
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
        
        //Calculate MenuView Content Width
        for item in menus {
            self.menuViewContentWidth += getTextSize(text: item).width
            menuViewContentWidthList.append(getTextSize(text: item).width)
        }
    }
    
    private func setupContentView(){
        for (index, _) in viewControllers.enumerated() {
            addContentView(index: index)
        }
    }
}

//MARK: - Tab Function
extension JTabBar {
    private func moveToTab(index:Int) {
        let scrollViewOffset = CGPoint(x: Int(self.scrollView.frame.width) * index, y: 0)
        
        UIView.animate(withDuration: scrollViewAnimationDuration, animations: {
            self.scrollView.setContentOffset(scrollViewOffset, animated: false)
        })

    }
    
    private func addContentView(index:Int) {
        let vc = viewControllers[index]
        vc.view.tag = index
        
        vc.willMove(toParent: self)
        
        self.addChild(vc)
        
        let x = vc.view.frame.width * CGFloat(index)
        let y = 0.0
        
        vc.view.frame = CGRect(x: x, y: y, width: vc.view.frame.width, height: self.scrollView.frame.height)
        
        self.scrollView.addSubview(vc.view)
        vc.didMove(toParent: self)
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
        var size = getTextSize(text: menus[indexPath.row])
        
        if self.scrollView.frame.width > self.menuViewContentWidth {
            self.menuView.isScrollEnabled = false
            let calWidth = (self.menuView.frame.width - self.menuViewContentWidth) / CGFloat(self.menuViewContentWidthList.count)
            
            size = CGSize(width: size.width + calWidth, height: self.borderMenuBottomView.frame.size.height)
        }
        
        //changed border of first index
        if indexPath.row == 0 {
            self.borderMenuBottomView.frame.size = CGSize(width: size.width, height: self.borderMenuBottomView.frame.size.height)
        }
        
        return CGSize(width: size.width, height: config.menuHeight)
    }
}

extension JTabBar: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {

            let indexPage = getIndexPageFor(contentOffset: scrollView.contentOffset.x)
            lastContentOffset = scrollView.contentOffset.x
        }
    }
}

//MARK: Utils
extension JTabBar {
    private func getTextSize(text:String) -> CGSize {
        let label = UILabel()
        label.text = text
        label.frame.size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        label.sizeToFit()
        label.frame.size = CGSize(width: label.frame.size.width + config.menuLeftMargin + config.menuRightMargin, height: label.frame.size.height)
        return label.frame.size
    }
}
