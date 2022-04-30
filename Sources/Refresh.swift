//
//  Refresh.swift
//  
//
//  Created by Wentong Song on 2022/4/30.
//

import Foundation
#if canImport(UIKit)
import UIKit


public extension UITableView{
    
}
/**
 刷新状态
 pulling状态包含刷新进度
 */
public enum RefreshStatus{
    case normal
    case pulling(CGFloat)
    case refreshing
    case ending
}
///刷新UI
open class RefreshView : UIView{
    var originalInset:UIEdgeInsets = .zero
    weak var scrollView:UIScrollView?
    var refreshEvent:DispatchObject?
    var status = RefreshStatus.normal
    func linkTo( myScroll:UIScrollView) {
        self.scrollView = myScroll
    }
    func beginRefreshing() {
        
    }
    func endRefreshing() {
        
    }
    static let contentOffset = "contentOffset"
    static let contentInset = "contentInset"
    static let contentSize = "contentSize"
    private func addObservers() {
        scrollView?.addObserver(self, forKeyPath: RefreshView.contentOffset, options: .new.union(.old), context: nil)
        scrollView?.addObserver(self, forKeyPath: RefreshView.contentInset, options: .new.union(.old), context: nil)
        scrollView?.addObserver(self, forKeyPath: RefreshView.contentSize, options: .new.union(.old), context: nil)
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
//        guard self.isUserInteractionEnabled else{
//            return
//        }
        if keyPath == RefreshView.contentSize{
            scrollViewContentSizeDidChange(with: change)
        }
        if keyPath == RefreshView.contentOffset{
            scrollViewContentOffsetDidChange(with: change)
        }
        if keyPath == RefreshView.contentInset{
            scrollViewContentInsetDidChange(with: change)
        }
        
    }
    func scrollViewContentOffsetDidChange(with change: [NSKeyValueChangeKey : Any]?)->Void{
        
    }
    func scrollViewContentInsetDidChange(with change: [NSKeyValueChangeKey : Any]?){
        
    }
    func scrollViewContentSizeDidChange(with change: [NSKeyValueChangeKey : Any]?){
        
    }
    
}
#endif
