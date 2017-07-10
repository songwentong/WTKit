//
//  Algorithm.swift
//  WTKit
//
//  Created by SongWentong on 07/07/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation
//sort
public func bubbleSort(array:[Int])->[Int]{
    var temp:Int
    var copyOfArray = array;
    for j in 0..<copyOfArray.count - 1 {
        for i in 0..<copyOfArray.count - 1 - j{
            if copyOfArray[i] > copyOfArray[i+1] {
                temp = copyOfArray[i]
                copyOfArray[i] = copyOfArray[i+1];
                copyOfArray[i+1] = temp
            }
        }
    }
    return copyOfArray
}
//插入法排序
public func insertionSort(array:[Int])->[Int]{
    var newArray = [Int]()
    var temp:Int
    for i in 0..<array.count{
        temp = array[i]
        if newArray.count == 0 {
            newArray.append(temp)
        }else{
            for j in 0..<newArray.count{
                if temp < newArray[j] {
                    newArray.insert(temp, at: j)
                }
            }
        }
    }
    return newArray
}
//选择排序
public func selectionSort(array:[Int])->[Int]{
    var result = [Int]()
    var copyOfArray = array
    while copyOfArray.count != 0 {
        var index = 0
        var max = copyOfArray[0]
        for i in 0..<copyOfArray.count{
            if copyOfArray[i] > max {
                index = i
            }
        }
        max = copyOfArray[index]
        copyOfArray.remove(at: index)
        result.append(max)
        
    }
    return result
}

//降序的快速排序
func quickSort(array:[Int], left:Int, right:Int){
    var copyOfArray = array
    if left >= right {
        return;
    }
    var i = left
    var j = right
    let key = copyOfArray[left]
    while i<j {
        while i<j && key <= copyOfArray[j] {
            j -= 1
        }
        copyOfArray[i] = copyOfArray[j]
        while j<j && key >= copyOfArray[i] {
            i += 1
        }
        copyOfArray[j] = copyOfArray[i]
    }
    copyOfArray[i] = key
    quickSort(array: copyOfArray, left: left, right: i - 1)
    quickSort(array: copyOfArray, left: i + 1, right: right)
}
