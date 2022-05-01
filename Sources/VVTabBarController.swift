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
    var tarBarHeight = 44
    var imageInsets = UIEdgeInsets.zero
//    open var middleEvent = DispatchWorkItem?
//    open var vvTabBar = VVTabBar()
//    open override var delegate: UITabBarControllerDelegate?
    
    var myActions = [DispatchWorkItem?]()
    var myViews = [VVBarView]()
    open var vvDelegate:UITabBarControllerDelegate?
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        DispatchQueue.main.async {
            self.setupActions()
            
        }
    }
    
    func setupActions() {
        guard let vcs = viewControllers else{return}
        let width = self.tabBar.bounds.width / vcs.count.cgFloatValue
        let height = self.tabBar.bounds.height
        for i in 0..<vcs.count{
            myActions.append(nil)
            let barview = VVBarView.init(frame: CGRect.init(x: i.cgFloatValue * width, y: 0, width: width, height: height))
            self.tabBar.addSubview(barview)
        }
        
    }
    ///针对对应的按钮设置独立的响应事件，而非展示
    open func setCustomAction(action:DispatchWorkItem?, with index:Int) {
        if index < myActions.count{
            myActions[index] = action
        }
    }
}
extension VVTabBarController: UITabBarControllerDelegate{
    open func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        guard let index = viewControllers?.firstIndex(of: viewController) else{
            return true
        }
        //当前index就是被选中的
        if index == selectedIndex{
            if let vcs = viewControllers{
                if index < vcs.count{
                    if let navi = vcs[index] as? UINavigationController{
                        if let vc = navi.topViewController as? UIViewControllerRefresh{
                            vc.vcRefresh()
                        }
                    }else if let vc = vcs[index] as? UIViewControllerRefresh{
                        vc.vcRefresh()
                    }
                    return false
                }
            }
            
        }else{
            if index < myActions.count{
                if let action = myActions[index]{
                    action.perform()
                    return false
                }
            }
        }
        return true
    }
    
    open func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        //refresh event
        tabBar.items?.forEach({ item in
            item.isEnabled = true
        })
    }
}
///页面刷新
public protocol UIViewControllerRefresh: NSObjectProtocol{
    func vcRefresh()
}
open class VVBarView: UIView{
    var label = UILabel()
    var colorPoint = UIView()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        addSubview(label)
        label.backgroundColor = .red
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.cornerRadius = 7.5
        label.textColor = .white
        label.frame = .init(x: 50, y: 10, width: 30, height: 15)
        label.text = "99+"
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
open class VVTabBar: UITabBar{
    
    
}
#endif
