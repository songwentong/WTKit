//
//  Chart.swift
//  WTKit
//
//  Created by SongWentong on 06/04/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//  
//  股票图绘制

import Foundation
import UIKit
public enum ChartViewDrawType:Int
{
    case KDJ//蜡烛图🕯
    case LINE//线条
    case VOL//柱状图📊
    case CIRCLE//圆圈⭕️
}
public protocol ChartViewDelegate
{
    
}
public protocol ChartViewDataSource:NSObjectProtocol
{

}

/*
    线条允许多条,其他的只允许有或者无
 */
public protocol CustomChartViewDataSource:ChartViewDataSource{
    //数值的数量
    func numberOfValues(in chartView:ChartView)->Int
    //线条的数量
    func numberOfLines(in chartView:ChartView)->Int
    //VOL
    func chartView(chartView:ChartView,VOLIndex:Int)->Int
    //蜡烛图
    func chartView(chartView:ChartView,KLineIndex:Int)->Int
    //圆圈
    func chartView(chartView:ChartView,circleIndex:Int)->Double
    /*
     lineindex 线条的索引
     valueIndex 位置的索引
     return value Double.nan if don't have value
     */
    func chartView(_ chartView:ChartView,_ lineIndex:Int,_ valueIndex:Int)->Double
    
    
}
open class ChartView:UIView{
    var datasource:ChartViewDataSource?
    var delegate:ChartViewDelegate?
    var numberOfCompoment = 1;
    open func reloadData(){
        
    }
}
