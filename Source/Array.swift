//
//  Array.swift
//  WTKit
//
//  Created by 宋文通 on 2018/6/23.
//  Copyright © 2018年 songwentong. All rights reserved.
//

import Foundation
//快速排序
extension Array{
    //排序n个元素要O(nlogn)次比较。在最坏状况下则需要O(n^2)次比较，但这种状况并不常见。
    public func wtSorted(by smallToBig:(Element, Element) -> Bool) -> [Element] {
        if self.count <= 1{return self}
        var left:[Element] = []
        var right:[Element] = []
        let pivot:Element = self[count - 1]
        for index in 0..<(count-1) {
            let element = self[index]
            if smallToBig(element,pivot){
                left.append(element)
            }else{
                right.append(element)
            }
        }
        left = left.wtSorted(by: smallToBig)
        left.append( pivot)
        right = right.wtSorted(by: smallToBig)
        left.append(contentsOf: right)
        return left
    }
}
