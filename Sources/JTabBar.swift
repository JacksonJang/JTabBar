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
    
    //MARK: - Button Menu Properties
    private var selectedBarAlignment: SelectedBarAlignment = .center
    private var lastContentOffset: CGFloat = 0.0
    
    private var pageWidth: CGFloat {
        return scrollView.frame.width
    }
    
    private var swipeDirection: SwipeDirection {
        if scrollView.contentOffset.x > lastContentOffset {
            return .left
        } else if scrollView.contentOffset.x < lastContentOffset {
            return .right
        }
        return .none
    }
    
    private var scrollPercentage: CGFloat {
        if swipeDirection != .right {
            let module = fmod(scrollView.contentOffset.x, pageWidth)
            return module == 0.0 ? 1.0 : module / pageWidth
        }
        return 1 - fmod(scrollView.contentOffset.x >= 0 ? scrollView.contentOffset.x : pageWidth + scrollView.contentOffset.x, pageWidth) / pageWidth
    }

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
    
    private lazy var menuBottomLineView:UIView = {
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
        self.menuView.addSubview(menuBottomLineView)
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
            
            size = CGSize(width: size.width + calWidth, height: self.menuBottomLineView.frame.size.height)
        }
        
        //changed border of first index
        if indexPath.row == 0 {
            self.menuBottomLineView.frame.size = CGSize(width: size.width, height: self.menuBottomLineView.frame.size.height)
        }
        
        return CGSize(width: size.width, height: config.menuHeight)
    }
}

extension JTabBar: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            updateMenuView()
            lastContentOffset = scrollView.contentOffset.x
        }
    }
    
    private func updateMenuView() {
        let indexPage = getIndexPageFor(contentOffset: scrollView.contentOffset.x)
        let newCurrentIndex = pageFor(indexPage: indexPage)
        self.currentIndex = newCurrentIndex
        let (fromIndex, toIndex, scrollPercentage) = progressiveIndicatorData(indexPage)
        var targetContentOffset: CGFloat = 0.0
        
        //Calculate Frame of menuBottomLineView
        let toFrame: CGRect = getToFrame(toIndex: toIndex)
        let fromFrame = menuView.layoutAttributesForItem(at: IndexPath(item: fromIndex, section: 0))!.frame
        var targetFrame = fromFrame
        targetFrame.size.height = menuBottomLineView.frame.size.height
        targetFrame.size.width += (toFrame.size.width - fromFrame.size.width) * scrollPercentage
        targetFrame.origin.x += (toFrame.origin.x - fromFrame.origin.x) * scrollPercentage
        
        menuBottomLineView.frame = CGRect(x: targetFrame.origin.x, y: menuBottomLineView.frame.origin.y, width: targetFrame.size.width, height: menuBottomLineView.frame.size.height)
        
        //Calculate Offset of menuView
        if menuView.contentSize.width > menuView.frame.size.width {
            let toContentOffset = contentOffsetForCell(withFrame: toFrame, andIndex: toIndex)
            let fromContentOffset = contentOffsetForCell(withFrame: fromFrame, andIndex: fromIndex)

            targetContentOffset = fromContentOffset + ((toContentOffset - fromContentOffset) * scrollPercentage)
        }
        
        menuView.setContentOffset(CGPoint(x: targetContentOffset, y: 0), animated: false)
    }
        
    private func getIndexPageFor(contentOffset: CGFloat) -> Int {
        return Int((contentOffset + 1.5 * pageWidth) / pageWidth) - 1
    }
    
    private  func pageFor(indexPage: Int) -> Int {
        if indexPage < 0 {
            return 0
        }
        if indexPage > viewControllers.count - 1 {
            return viewControllers.count - 1
        }
        return indexPage
    }
    
    private func progressiveIndicatorData(_ indexPage: Int) -> (Int, Int, CGFloat) {
        let count = viewControllers.count
        var fromIndex = currentIndex
        var toIndex = currentIndex
        let direction = swipeDirection

        if direction == .left {
            if indexPage > count - 1 {
                fromIndex = count - 1
                toIndex = count
            } else {
                if self.scrollPercentage >= 0.5 {
                    fromIndex = max(toIndex - 1, 0)
                } else {
                    toIndex = fromIndex + 1
                }
            }
        } else if direction == .right {
            if indexPage < 0 {
                fromIndex = 0
                toIndex = -1
            } else {
                if self.scrollPercentage > 0.5 {
                    fromIndex = min(toIndex + 1, count - 1)
                } else {
                    toIndex = fromIndex - 1
                }
            }
        }
        
        return (fromIndex, toIndex, scrollPercentage)
    }
    
    func getToFrame(toIndex: Int) -> CGRect {
        var toFrame = CGRect.zero
        let numberOfItems = menuView.dataSource!.collectionView(menuView.self, numberOfItemsInSection: 0)
        
        if toIndex < 0 || toIndex > numberOfItems - 1 {
            if toIndex < 0 {
                let cellAtts = menuView.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))
                toFrame = cellAtts!.frame.offsetBy(dx: -cellAtts!.frame.size.width, dy: 0)
            } else {
                let cellAtts = menuView.layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: 0))
                toFrame = cellAtts!.frame.offsetBy(dx: cellAtts!.frame.size.width, dy: 0)
            }
        } else {
            toFrame = menuView.layoutAttributesForItem(at: IndexPath(item: toIndex, section: 0))!.frame
        }
        
        return toFrame
    }
    
    private func contentOffsetForCell(withFrame cellFrame: CGRect, andIndex index: Int) -> CGFloat {
        let sectionInset = (menuView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset // swiftlint:disable:this force_cast
        var alignmentOffset: CGFloat = 0.0

        switch selectedBarAlignment {
        case .left:
            alignmentOffset = sectionInset.left
        case .right:
            alignmentOffset = menuView.frame.size.width - sectionInset.right - cellFrame.size.width
        case .center:
            alignmentOffset = (menuView.frame.size.width - cellFrame.size.width) * 0.5
        case .progressive:
            let cellHalfWidth = cellFrame.size.width * 0.5
            let leftAlignmentOffset = sectionInset.left + cellHalfWidth
            let rightAlignmentOffset = menuView.frame.size.width - sectionInset.right - cellHalfWidth
            let numberOfItems = menuView.dataSource!.collectionView(menuView.self, numberOfItemsInSection: 0)
            let progress = index / (numberOfItems - 1)
            alignmentOffset = leftAlignmentOffset + (rightAlignmentOffset - leftAlignmentOffset) * CGFloat(progress) - cellHalfWidth
        }

        var contentOffset = cellFrame.origin.x - alignmentOffset
        contentOffset = max(0, contentOffset)
        contentOffset = min(menuView.contentSize.width - menuView.frame.size.width, contentOffset)
        return contentOffset
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
