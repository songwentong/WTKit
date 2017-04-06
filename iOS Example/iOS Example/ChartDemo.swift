//
//  ChartDemo.swift
//  iOS Example
//
//  Created by SongWentong on 06/04/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation
import UIKit
import WTKit
public class ChartViewDemoVC:UIViewController{
    @IBOutlet weak var chartView: ChartView!
    public override func viewDidLoad() {
        chartView.dataSource = self
    }
}
extension ChartViewDemoVC:ChartViewDataSource{
    //values count
    public func numberOfValues(in chartView:ChartView)->Int{
        return 10
    }
    //draw type
    public func drawType(of chartView:ChartView)->ChartViewDrawType{
        return .NONE
    }
    //min
    public func minValue(of chartView:ChartView)->Double{
        return 0
    }
    //max
    public func maxValue(of ChartView:ChartView)->Double{
        return 100
    }
}
extension ChartViewDemoVC:LineChartViewDataSource{
    //number of lines
    public func numberOfLines(in chartView:ChartView)->Int{
        return 2
    }
    //line color
    public func chartView(_ chartView:ChartView,colorForLineAt index:Int)->UIColor{
        if index == 0 {
            return UIColor.blue
        }
        return UIColor.red
    }
    //values
    public func chartView(_ chartView:ChartView,_ lineIndex:Int,_ valueIndex:Int)->Double{
        if lineIndex == 0 {
            if valueIndex < 2 {
                return Double.nan
            }
                return Double(valueIndex * valueIndex * 5)
        }
        return Double(valueIndex * valueIndex * 4)
    }
}
