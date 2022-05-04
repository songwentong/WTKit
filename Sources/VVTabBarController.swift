//
//  File.swift
//  
//
//  Created by Wentong Song on 2022/5/1.
//

import Foundation
#if canImport(UIKit)
import UIKit
open class VVTabBarController: UITabBarController{
    open var tarBarHeight:CGFloat = 48
//    var imageInsets = UIEdgeInsets.zero
//    open var middleEvent = DispatchWorkItem?
//    open var vvTabBar = VVTabBar()
//    open override var delegate: UITabBarControllerDelegate?
    
    var myActions = [DispatchWorkItem?]()
    open var myViews = [VVBarItem]()
    open var vvDelegate:UITabBarControllerDelegate?
    open var images = [UIImage]()
    open var selectedImages = [UIImage]()
    open var vvTabBar = VVTabBar.init(frame: .zero)
    open override func viewDidLoad() {
        super.viewDidLoad()
//        self.additionalSafeAreaInsets
        DispatchQueue.main.async {
            self.resetUI()
            self.updateUI(with: 0)
        }
        myViews.forEach { ele in
//            ele.startLabelAnimation()
        }
    }
    
    func resetUI() {
        guard let vcs = viewControllers else{return}
        let width = self.tabBar.bounds.width / vcs.count.cgFloatValue
        let height = tarBarHeight
        var safeBottom:CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
//            let topPadding = window?.safeAreaInsets.top
            let bottomPadding:CGFloat = window?.safeAreaInsets.bottom ?? 0
            safeBottom = bottomPadding
        }
        vvTabBar.frame = .init(x: 0, y: UIScreen.mainScreenHeight - (safeBottom + height), width: view.bounds.width, height: (height + safeBottom))
        self.view.addSubview(vvTabBar)
//        vvTabBar.backgroundColor = .red
        for i in 0..<vcs.count{
            myActions.append(nil)
            let barview = VVBarItem.init(frame: CGRect.init(x: i.cgFloatValue * width, y: 0, width: width, height: height))
            if i < images.count{
                barview.iconImageView.image = images[i]
            }
            if i < selectedImages.count{
                
            }
            vvTabBar.addSubview(barview)
            vvTabBar.items.append(barview)
            myViews.append(barview)
        }
        vvTabBar.items.forEach { item in
            item.button.addTarget(self, action: #selector(itemPressed(with:)), for: .touchUpInside)
        }
        
    }
    ///针对对应的按钮设置独立的响应事件，而非展示
    open func setCustomAction(action:DispatchWorkItem?, for index:Int) {
        if index < myActions.count{
            myActions[index] = action
        }
    }
    func updateUI(with index:Int) {
        for (index1,ele) in myViews.enumerated(){
            if index1 == index{
                ele.iconImageView.image = selectedImages[index1]
            }else{
                ele.iconImageView.image = images[index1]
            }
        }
    }
    @objc func itemPressed(with sender:UIButton) {
        guard let item = sender.superview as? VVBarItem else{return}
        guard let index = vvTabBar.items.firstIndex(of: item) else{return}
        if selectedIndex != index{
            action(with: index)
        }else{
            refresh(with: index)
        }
        vvTabBar.selectedIndex = selectedIndex
        updateUI(with: selectedIndex)
    }
    func action(with index:Int) {
        if index < myActions.count{
            if let action = myActions[index]{
                action.perform()
                return
            }else{
            }
        }else{
        }
        selectedIndex = index
    }
    func refresh(with index:Int) {
        guard let vcs = viewControllers else{return}
        if let navi = vcs[index] as? UINavigationController{
            if let vc = navi.topViewController as? UIViewControllerRefresh{
                vc.vcRefresh()
            }
        }else if let vc = vcs[index] as? UIViewControllerRefresh{
            vc.vcRefresh()
        }
    }
}
///页面刷新
public protocol UIViewControllerRefresh: NSObjectProtocol{
    func vcRefresh()
}
open class VVBarItem: UIView{
    open var imageSize:CGSize = CGSize.init(width: 40, height: 40)
    var badagelabel = UILabel()
    var colorPoint = UIView()
    var contentView = UIView()
    var titleLabel = UILabel()
    
    
    open var iconImageView = UIImageView()
    open var button = UIButton.customButton
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(titleLabel)
        button.frame = bounds
        addSubview(button)
        button.backgroundColor = .clear
        addSubview(iconImageView)
        addSubview(badagelabel)
        
        
        badagelabel.backgroundColor = .red
        badagelabel.font = .systemFont(ofSize: 10)
        badagelabel.textAlignment = .center
        badagelabel.cornerRadius = 9
        badagelabel.textColor = .white
        badagelabel.font = .systemFont(ofSize: 9)
        badagelabel.frame = .init(x: bounds.width / 2, y: bounds.height / 2 - 18, width: 18, height: 18)
        badagelabel.text = "9"
        
        iconImageView.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24)
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.center = button.center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 10)
        titleLabel.text = "微信"
    }
    public func startLabelAnimation() {
        UIView.animate(withDuration: 2, delay: 1, options: .autoreverse) {
            self.badagelabel.center = .init(x: self.badagelabel.center.x, y: self.badagelabel.center.y - 10)
        } completion: { _ in
            
        }
    }
    public func endLabelAnimation() {
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
open class VVTabBar: UIView{
    var items = [VVBarItem]()
    var separateLine = UIView()
    open var selectedIndex = -1
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(separateLine)
        backgroundColor = "f8".hexColor
        separateLine.translatesAutoresizingMaskIntoConstraints = false
        separateLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        separateLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        separateLine.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        separateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        separateLine.frame = .init(x: 0, y: 0, width: frame.width, height: 1)
        separateLine.backgroundColor = "e5".hexColor
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func resetUI() {
        
    }
    func upateUI() {
        
    }
}
#endif
