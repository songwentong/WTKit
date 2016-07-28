
# WTKit
[![Build Status](https://travis-ci.org/swtlovewtt/WTKit.svg?branch=master)](https://travis-ci.org/swtlovewtt/WTKit)

WTKit是我的swift开发积累

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
- [x] 更多

# Foundation 扩展

- WTPrint
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
- URLSession

```swift
        let url = "https://www.apple.com"
        let task = URLSession.wt_dataTask(with: url) { (data, response, error) in
            //do somthing
            print(data)
        }
        // set image
        let imageView:UIImageView = UIImageView()
        task.imageHandler = {(image:UIImage?,error:NSError?) in
            imageView.image = image
        }
        // or get json
        task.jsonHandler = {(anyObject:AnyObject?,error:NSError?) in
            print(anyObject)
        }
        task.resume()
```
- URLRequest

```swift
//create a request instance
//optional parameters: method,parameters,headers
 public static func request(_ url:String, method:String?="GET", parameters:[String:String]?=[:],headers: [String: String]? = [:]) -> URLRequest

 URLRequest.request(with:"", method: "", parameters: nil, headers: nil)
 URLRequest.request(with:"")
```
> 不需要填的参数可以不填

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
//custom arrow image
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
