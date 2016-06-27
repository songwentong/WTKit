
# WTKit
[![Build Status](https://travis-ci.org/swtlovewtt/WTKit.svg?branch=master)](https://travis-ci.org/swtlovewtt/WTKit)

Swift Extensions
# Foundation Extensions 


- WTPrint 
```swift
//this method only print at debug mode
WTPrint("wt print \(self)")
//AppDelegate.swift[19], application(_:didFinishLaunchingWithOptions:) wt print <WTKit.AppDelegate: 0x7fde38509d80>

DEBUGBlock { 
            //code will run at debug mode
        }
//note: Build Settings -> Other Swift Flags -> Debug -> -D DEBUG
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
- NRLSession 
```swift

```
- URLRequest 
```swift
//create a request instance
//optional parameters: method,parameters,headers
 public static func request(_ url:String, method:String?="GET", parameters:[String:String]?=[:],headers: [String: String]? = [:]) -> URLRequest
 
 URLRequest.request("", method: "", parameters: nil, headers: nil)
```

- OperationQueue
```swift
        OperationQueue.main {
            let thread = NSThread.currentThread()
            print("main:\(thread) threadPriority:\(thread.threadPriority)")
            //main:<NSThread: 0x7ffb83c02030>{number = 1, name = main} threadPriority:0.758064516129032
        }
        OperationQueue.background {
            let thread = NSThread.currentThread()
            print("background:\(thread) threadPriority:\(thread.threadPriority)")
            //background:<NSThread: 0x7ffb83dc79e0>{number = 4, name = (null)} threadPriority:0.0
        }
        OperationQueue.userInteractive {
            let thread = NSThread.currentThread()
            print("userInteractive:\(thread) threadPriority:\(thread.threadPriority)")
            //userInteractive:<NSThread: 0x7ffb83d6ec50>{number = 2, name = (null)} threadPriority:0.5
        }
        OperationQueue.globalQueue {
            let thread = NSThread.currentThread()
            print("globalQueue:\(thread) threadPriority:\(thread.threadPriority)")
            //globalQueue:<NSThread: 0x7ffb83c42d20>{number = 3, name = (null)} threadPriority:0.5
        }
```
- String
```swift
let string = "swift"
print(string.length)//5
```
- NSDate
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
NSNotificationCenter.defaultCenter().addObserverForName(kWTReachabilityChangedNotification, object: nil, queue: nil) { [weak self](notification) in
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
UIColor.colorWithHexString("ff0000",alpha: 0.5)//red colour with alpha : 0.5
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
- UIButton
```swift
// request image from internet(address is url),the set the image for the state,
// the place holder will be the default image
requestButton.setImageWith("url", forState: .Normal,placeHolder: nil)
```
- UIImage
```swift
// create a rounded corner image for reciver
let image:UIImage = (self.imageView.image?.imageWithRoundCornerRadius(30))
```
- UIImageView
```swift
//set image with a url
imageView.setImageWith("url")

//set hight lighted image with a url,and set a place holder image
imageView.sethighlightedImageWith("url", placeHolder: placeHolderImage)

```
- UIViewController
```swift
//show loading activity indicator
self.showLoadingView()

//hide loading activity indicator 
self.hideLoadingView()


//show tip with String
self.showHudWithTip("热烈欢迎")
```

- UIView
```swift
let image:UIImage = self.view.snapShot()//get a snap shot image
let pdf:NSData = self.view.pdf()//get a pdf shot 
```
- UIScrollView || UITableView
```swift
//pull to refresh(very useful)
self.tableView.refreshHeader = RefreshHeader.headerWithRefreshing({ 
            printf("refresh data from internet")
        })
        
//stop refresh        
self.tableView.stopLoading()

//Localizations 
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
//create snapshot
let image:UIImage =  self.view.layer.snapShot()
//pause layer animation
self.view.layer.pauseAnimation()
//resume layer animation
self.view.layer.resumeAnimation()
```

