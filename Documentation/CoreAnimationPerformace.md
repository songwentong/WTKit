
iOS性能优化
### Use Opaque Layers Whenever Possible
1.少用不透明的Layer,这样可以减少渲染

### Use Simpler Paths for CAShapeLayer Objects
2.CAShapeLayer图形绘制尽量简化.如果path过于复杂,光栅化的成本就会过高,如果一个layer的大小频繁更改（因此必须频繁重绘），则绘制所花费的时间可能加起来并成为性能瓶颈。

一个优化的方案是把一个复杂的图形变成简单的图
形.绘制一堆简单的比绘制一个复杂的要更高效.因为重绘操作在CPU上,而合成发生在GPU上,在优化之前需要先检测性能.
### Set the Layer Contents Explicitly for Identical Layers
3.多个相同的layer设置想同的内容
如果多个layer显示想同的图片,可以把第一个layer的contents直接设置到其他layer上,这样不用为图片开辟新的内存空间

### Always Set a Layer’s Size to Integral Values
4.把layer的尺寸设置为整数

### Use Asynchronous Layer Rendering As Needed
5.使用异步绘制
drawLayer:inContext: 和drawrect是在主线程同步执行的.
如果发现动画卡顿的话,使用drawsAsynchronously,可以在后台线程处理

### Specify a Shadow Path When Adding a Shadow to Your Layer
6.指定阴影路径,否则系统需要去计算

7.抗锯齿也比较吃性能,但是效果好

## UIKit
### 约束条数减少,或用Frame,如果frame做预加载就更好了
### 合理运用多线程计算 
###
###
###
