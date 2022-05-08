
### App启动过程
1. 解析Info.plist
2. Mach-O加载
3. 程序执行

- 详细描述
1. 加载dyld到App进程
2. 加载动态库（包括所依赖的所有动态库）
3. Rebase
4. Bind
5. 初始化Objective C Runtime
6. 其它的初始化代码

- 在Xcode中，可以通过设置环境变量来查看App的启动时间，DYLD_PRINT_STATISTICS和DYLD_PRINT_STATISTICS_DETAILS。

### 启动优化
1. 移除不需要用到的动态库
2. 移除不需要用到的类
3. 合并功能类似的类和扩展
4. 尽量避免在+load方法里执行的操作，可以推迟到+initialize方法中。


### 如何抓https包
1. 将Charles的根证书(Charles Root Certificates)安装到Mac上。
2. 步骤二：Mac信任Charles的根证书。
3. 步骤三：将Charles证书安装到移动设备上。
4. 步骤四：移动设备信任Charles证书。
5. 步骤五：Charles设置“Enable SSL Proxying”

### 如何反抓包
使用自签证书 ssl-pinning模式
客户端本地做证书校验,并且设置不仅仅校验公钥,设置完整的正式校验模式。

这么做为什么是安全的？了解HTTPS的人都知道，整个验证体系中，最核心的实际上是服务器的私钥。私钥永远，永远也不会离开服务器，或者以任何形式向外传输。私钥和公钥是配对的，如果事先在客户端预留了公钥，只要服务器端的公钥和预留的公钥一致，实际上就已经可以排除中间人攻击了。

https双向认证

### 泛型的使用场景
作为属性,也可以作为方法参数

### 大量数据刷新的处理
动态更新局部

### extension不能被继承
一个类的extension实现了一条协议,自身是可以使用的,但是子类不能用,子类不继承任何extension功能

### socket
1. 丢包

2. 粘包
https://www.cnblogs.com/ChengYing-Freedom/p/8006497.html
粘包通常出现在TCP的协议里面，对于UDP来说是不会出现粘包状况的，之所以出现这种状况的原因，涉及到一种名为Nagle的算法。
3. 断包

### 多线程的应用

### struct VC class
struct更小,更适合在对象之间拷贝和多线程访问,
不容易内存泄露,class是面向对象思想,struct可以用面向协议思想开发,协议的复用性更高.

struct只有被修改的时候才会真的copy,平时不copy

https://stackoverflow.com/questions/24232799/why-choose-struct-over-class/24243626#24243626
UPDATE (27 Mar 2018):

As of Swift 4.0, Xcode 9.2, running Release build on iPhone 6S, iOS 11.2.6, Swift Compiler setting is -O -whole-module-optimization:

class version took 2.06 seconds
struct version took 4.17e-08 seconds (50,000,000 times faster)
(I no longer average multiple runs, as variances are very small, under 5%)

Note: the difference is a lot less dramatic without whole module optimization. I'd be glad if someone can point out what the flag actually does.


### swift protocol 和OC protocol不同
1. OC支持可选方法,一般有一个NSObjectProtocol作为根协议
2. swift协议可以被struct实现
3. swift可以默认一个扩展来实现

### swift 如何保证单例
用@available 把init和new方法给注解为不可用的.

### 图片压缩
1. 可以用系统方法,提供缩放比
2. 可以减少颜色位数,比如24位的图改为8位

### 大图片加载
CATileLayer,使用的是动态局部加载.默认加载延迟是0.25秒,提升了体验效果.

## Core Animation 性能技巧
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

### 泛型的使用
 泛型Model
```swift
struct BaseModel<T:Codable>:Codable{
  var data:T
  var code:Int
  var msg:Int
}
```
protocol 使用泛型
```swift
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

struct IntStack: Container {
    // original IntStack implementation
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    // conformance to the Container protocol
    typealias Item = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}
```
可以定义为泛型
```swift
struct Stack<Element>: Container {
    // original Stack<Element> implementation
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // conformance to the Container protocol
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}
```

### rethrow是干嘛的
rethrow是用于闭包抛出的异常再次被抛出

### extension 的运用
1.Extension给Model扩展
举个例子
```swift
class MyModel:Codable{
var time:TimeInterval
//0 male 1 female
var sex:Int
var subscribed:Int
}
```
```swift
extension MyModel{
  //根据时间戳给出字符串
func dateStr()->String{
let df = DateFormatter()
let date = Date(time)
return df.stringFromDate(date)
}
///根据性别给出图片
func maleColor()->UIImage{
if sex == 0{
return "male".namedUIImage
}else{
return "female".namedUIImage
}
}

///根据字段给出字符串
func subscribeText()-> String{
  return "\(subscribed)" + "粉丝".localText
}
}
```
### 响应链


### Optional原理
是一个enum
有case none
和case some<Wrapped>

### strong和copy区别
结论：源对象为不可变字符串而言，不论使用copy还是strong属性，所对应的值是不发生变化，strong和copy并没有开辟新的内存，即并不是深拷贝。此时，使用copy或是strong，并没有对数据产生影响。
结论：数据源为可变字符串而言，使用copy申明属性，会开辟一块新的内存空间存放值，源数据不论怎么变化，都不会影响copy属性中的值，属于深拷贝；使用strong申明属性，不会开辟新的内存空间，只会引用到源数据内存地址，因此源数据改变，则strong属性也会改变，属于浅拷贝。

### 闭包详解


### NSSet为什么比Array性能高，是如何去重的
  NSSet实现原理
