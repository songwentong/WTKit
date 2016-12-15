
# WTKit
[![Build Status](https://travis-ci.org/swtlovewtt/WTKit.svg?branch=master)](https://travis-ci.org/swtlovewtt/WTKit)

WTKit是我和朋友们的swift开发积累

## 功能
- [x] 方便的请求/响应方法
- [x] debug输出
- [x] 方便的线程切换
- [x] 网络状态监听(Reachability)
- [x] UIColor快捷创建
- [x] UIButton和UIImageVie的图片缓存
- [x] UITableView下拉刷新
- [x] UIView截屏为图片
- [x] 常用Hud提示
- [x] 应用新版本首次启动区分
- [x] 自动创建Model,解析数据,归档功能
- [x] 更多

## 开发环境
- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.0+
- Swift 3.0

## 集成
把WTKit下的四个文件拷贝进应用就可以了

## 和我交流

- 如果你 **找到一个bug**, 打开一个 issue.
- 如果你 **有一个功能请求**, 打开一个 issue.
- 如果你 **想来做出贡献**, 可以提交一个pull request.

## 安装
>WTKit需要iOS8或者 OS X Mavericks (10.9)

### CocoaPods

暂未集成

### 手动安装
把WTKit下的几个文件拷贝过来即可

## 使用

### 自动Model解析功能

用于自动把JSON数据读出来赋值给属性
- [视频教程地址(YouTube)](https://www.youtube.com/watch?v=kvj7Jkn0liw&feature=youtu.be)
- [视频教程地址(优酷)](http://v.youku.com/v_show/id_XMTgzMTkxMDYzNg==.html)
```swift

{
  "tz": 8,
  "area": "HK",
  "tz_name": "Asia/Hong_Kong",
  "id": "101819729",
  "current": {
    "current_version": "69e14038fd7bbe93ec5a259e36b48173"
  },
  "name": "Hong Kong",
  "province": "Hong Kong"
}
public class WeatherModel: NSObject,WTJSONModelProtocol {
    var tz:String?
    var area:String?
    var tz_name:String?
    var id:String?
    var name:String?
    var province:String?
    var current:CurrentModel?
    var day:DayModel?
    public func WTJSONModelClass(for property:String)->AnyObject?{
        if (property == "current") {
            return CurrentModel()
        }
        return nil
    }
}
public class CurrentModel: NSObject {
    var current_version:String?
    public func WTJSONModelClass(for property:String)->AnyObject?{
        return CurrentDetailModel()
    }
}

//一行代码解析
weatherModel.wt(travel: jsonObject)

注意,在包含自定义属性的类中实现一下WTJSONModelProtocol协议,让程序在运行时知道得到的数据是什么
```

### WTPrint

用于方便的查看放钱输出所在的文件,方法,行数,并且在DEBUG模式下输出

```swift
public func WTPrint<T>(_ items:T,
             separator: String = " ",
             terminator: String = "\n",
             file: String = #file,
             method: String = #function,
             line: Int = #line)

WTPrint("wt print \(self)")
//AppDelegate.swift[19], application(_:didFinishLaunchingWithOptions:) wt print <WTKit.AppDelegate: 0x7fde38509d80>
```
> 注意,swift需要设置一下debug: Build Settings -> Other Swift Flags -> Debug -> -D DEBUG

### 创建请求

```swift
import WTKit
let task = WTKit.dataTask(with: "https://www.apple.com") 
task.completionHandler = { [weak self](data, response, error) in
              print(response) //服务端响应
              print(data)     //服务端数据
              print(error)    //得到的错误
        }
task.resume()
```
> WTKit中的网络请求是异步完成的.

### 结果处理

- 数据响应
- 字符串
- JSON

#### 数据响应

```swift
let task = WTKit.dataTask(with: "https://www.apple.com") 
task.completionHandler = { [weak self](data, response, error) in
              print(response) //服务端响应
              print(data)     //服务端数据
              print(error)    //得到的错误
        }
task.resume()
```
#### 字符串

```swift
task.stringHandler = {(string:String?,error:NSError?)in
            print(string)
        }
```
#### JSON

```swift
task.jsonHandler = {(object:AnyObject?,error:NSError?) in
            print(object)
        }
```


### 认证

认证使用的系统框架的认证[`URLCredential`和`URLAuthenticationChallenge`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLAuthenticationChallenge_Class/Reference/Reference.html).

**支持的认证方案**

- [HTTP Basic](http://en.wikipedia.org/wiki/Basic_access_authentication)
- [HTTP Digest](http://en.wikipedia.org/wiki/Digest_access_authentication)
- [Kerberos](http://en.wikipedia.org/wiki/Kerberos_%28protocol%29)
- [NTLM](http://en.wikipedia.org/wiki/NT_LAN_Manager)

## 高级用法

> WTKit 的请求方法基于 `NSURLSession` 和 Foundation URL Loading System 编写. 为了熟悉这个框架, 它推荐你熟悉网络底层的概念和功能.

**推荐阅读**

- [URL Loading System Programming Guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html)
- [NSURLSession Class Reference](https://developer.apple.com/library/mac/documentation/Foundation/Reference/NSURLSession_class/Introduction/Introduction.html#//apple_ref/occ/cl/NSURLSession)
- [NSURLCache Class Reference](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLCache_Class/Reference/Reference.html#//apple_ref/occ/cl/NSURLCache)
- [NSURLAuthenticationChallenge Class Reference](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLAuthenticationChallenge_Class/Reference/Reference.html)


#### App Transport Security (ATS)
由于苹果强制使用https协议,http的请求已经被拒绝,苹果的ATS系统重写了整个认证系统,除非你在app的plist内配置ATS设置禁用来允许你的app评估服务端信任

如果你遇到了这样的问题,你可以在`Info.plist`解决这个问题
```xml
<dict>
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>example.com</key>
			<dict>
				<key>NSExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSExceptionRequiresForwardSecrecy</key>
				<false/>
				<key>NSIncludesSubdomains</key>
				<true/>
				<!-- Optional: Specify minimum TLS version -->
				<key>NSTemporaryExceptionMinimumTLSVersion</key>
				<string>TLSv1.2</string>
			</dict>
		</dict>
	</dict>
</dict>
```  

- NSObject

```swift

```
- Data

```swift
//convert to string(utf-8)
public func toUTF8String()->String
//parse json
public func parseJson()->AnyObject?

```

- OperationQueue

```swift
OperationQueue.main {
    let thread = Thread.current()
    print("main:\(thread) threadPriority:\(thread.threadPriority) qualityOfService:\(thread.qualityOfService.rawValue)")
}
OperationQueue.background {
    let thread = Thread.current()
    print("background:\(thread) threadPriority:\(thread.threadPriority) qualityOfService:\(thread.qualityOfService.rawValue)")

}
OperationQueue.userInteractive {
    let thread = Thread.current()
    print("userInteractive:\(thread) threadPriority:\(thread.threadPriority) qualityOfService:\(thread.qualityOfService.rawValue)")
}
OperationQueue.globalQueue {
    let thread = Thread.current()
    print("globalQueue:\(thread) threadPriority:\(thread.threadPriority) qualityOfService:\(thread.qualityOfService.rawValue)")
}

/*
//print
main:<NSThread: 0x7fbd40e04f40>{number = 1, name = main} threadPriority:0.758064516129032 qualityOfService:-1
globalQueue:<NSThread: 0x7fbd40c18b60>{number = 5, name = (null)} threadPriority:0.5 qualityOfService:-1
userInteractive:<NSThread: 0x7fbd40d10c10>{number = 3, name = (null)} threadPriority:0.5 qualityOfService:33
background:<NSThread: 0x7fbd40c7c540>{number = 4, name = (null)} threadPriority:0.0 qualityOfService:9

*/
```

- String

```swift
let string = "swift"
print(string.length)//5
```

- Date

```swift
// Get just one calendar unit value
 public func numberFor(component unit:Calendar.Unit)->Int{

date.numberFor(component: .year)
//2016

let date = Date()
print("year:\(date.numberForComponent(.year)) month:\(date.numberForComponent(.month)) day:\(date.numberForComponent(.day))")
//year:2016 month:6 day:15        
```
- WTReachability

monitor the network state of an iOS device
```swift
var reachability:WTReachability = WTReachability.reachabilityWithHostName("www.apple.com")
reachability.startNotifier()
NotificationCenter.default().addObserver(forName: NSNotification.Name(rawValue: kWTReachabilityChangedNotification), object: nil, queue: nil) { [weak self](notification) in
            let reachability:WTReachability = notification.object as! WTReachability
            print(reachability.currentReachabilityStatus())
        }
```

# UIKit Extensions
- UIColor

```swift
UIColor.colorWithHexString("#3")//result is #333333
UIColor.colorWithHexString("333333")//result is #333333
UIColor.colorWithHexString("#333333")//result is #333333
UIColor.colorWithHexString("ff0000",alpha: 0.5)//red color with alpha : 0.5
```
- UIApplication

```swift
//build version
UIApplication.buildVersion()
//app version
let appVersion:String = UIApplication.appVersion()
//documents path
let docPath:String = UIApplication.documentsPath()


//check if this launch is first launch,can use for everywhere,even use twice
UIApplication.firstLaunchForBuild { [weak self](isFirstLaunchEver) in
            if isFirstLaunchEver{
                print("this is first launch")
            }else{
                print("this is not first launch")
            }
        }
```
> firstLaunchForBuild 这个方法在应用内多次条用效果是一样的,只要是首次启动,
  无论调用几次都是首次启动,请放心使用

- UIButton
请求图片后缓存到本地

```swift

requestButton.setImageWith("url", forState: .Normal,placeHolder: nil)
```
- UIImage

图片切成圆角的

```swift
let image:UIImage = (self.imageView.image?.imageWithRoundCornerRadius(30))
```
- UIImageView
请求图片,并缓存到本地,下次设置图片读取缓存的

```swift
//set image with a url
imageView.setImageWith("url")

//set hight lighted image with a url,and set a place holder image
imageView.sethighlightedImageWith("url", placeHolder: placeHolderImage)

```
- UIViewController
loading提示框和和tip

```swift
//显示loading
self.showLoadingView()

//隐藏loading
self.hideLoadingView()


//底部的小tip
self.showHudWithTip("热烈欢迎")
```

- UIView
UIView截屏

```swift
let image:UIImage = self.view.snapShot()//get a snap shot image
let pdf:Data = self.view.pdf()//get a pdf shot
```
- UIScrollView
下拉刷新
```swift
//这里设置一下刷新头,把刷新方法写到block中
self.tableView.refreshHeader = RefreshHeader.headerWithRefreshing({
            printf("refresh data from internet")
        })

//停止刷新
self.tableView.stopLoading()

//本地化设置,有默认的,是英文的
tableView.refreshHeader?.setTitle("加载中...", forState: .Loading)
tableView.refreshHeader?.setTitle("下拉刷新", forState: .PullDownToRefresh)
tableView.refreshHeader?.setTitle("松开刷新", forState: .ReleaseToRefresh)
tableView.refreshHeader?.dateStyle = "yyyy-MM-dd"
tableView.refreshHeader?.lastUpdateText = "上次刷新时间"
//下拉刷新的箭头地址
tableView.refreshHeader?.arrowImageURL = "http://ww4.sinaimg.cn/mw690/47449485jw1f4wq45lqu6j201i02gq2p.jpg"

```
- CALayer

```swift
//创建UIImage的截屏
let image:UIImage =  self.view.layer.snapShot()
//暂停动画
self.view.layer.pauseAnimation()
//继续动画
self.view.layer.resumeAnimation()
```


## 证书

WTKit发布在MIT证书下,详情请看LICENSE
