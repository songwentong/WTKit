
# WTKit
[![Build Status](https://travis-ci.org/swtlovewtt/WTKit.svg?branch=master)](https://travis-ci.org/swtlovewtt/WTKit)

WTKit is my Code accumulation

[中文Readme(Zh_cn)](https://github.com/swtlovewtt/WTKit/blob/master/README_中文.md)


## Features
- [x] Convenient request / response method
- [x] debug print
- [x] Convenient thread Switch
- [x] network status observe
- [x] Convenient UIColor create
- [x] UIButton and UIImageVie image download,cache
- [x] UITableView pull to refresh
- [x] UIView screenshot image
- [x] Hud
- [x] launch time count for build
- [x] auto create Model from json,auto set value from json data,auto write to json
- [x] More

## Requirements
- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.0+
- Swift 3.0

## Installation
Copy sources from WTKit
## Communication

- if you  **found a bug**, open an issue.
- if you  **have a feature request**, open an issue.
- if you  **want to contribute**, submit a pull request.

### CocoaPods

not integrate yet

### Manually
copy sources from WTKit

## Usage

### Automatically create model classes
use for create model classes from json data automatically,and their instance can auto update property from json data
- [Video Guide(YouTube)](https://www.youtube.com/watch?v=kvj7Jkn0liw&feature=youtu.be)
- [Video Guide(youku)](http://v.youku.com/v_show/id_XMTgzMTkxMDYzNg==.html)
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
//WTKit can read json and parse to class like below,the model class's instances can update json value to their properties
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

//auto update property from json data
weatherModel.wt(travel: jsonObject)

Note that the WTJSONModelProtocol protocol is implemented in the class that contains the custom properties so that the program knows what data is available at runtime
```

### WTPrint

Used to facilitate the view of the money output where the file, method, line number, and in DEBUG mode output
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
> note,swift need set debug: Build Settings -> Other Swift Flags -> Debug -> -D DEBUG
### create data task

```swift
import WTKit
let task = WTKit.dataTask(with: "https://www.apple.com") 
task.completionHandler = { [weak self](data, response, error) in
              print(response) //response
              print(data)     //data
              print(error)    //error
        }
```
> Networking in WTKit is done asynchronously.
### complection handling
- data response
- string
- JSON
- UIImage

#### data response
```swift
let task = WTKit.dataTask(with: "https://www.apple.com") 
task.completionHandler = { [weak self](data, response, error) in
              print(response) //response
              print(data)     //data
              print(error)    //error
        }
```
#### string

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


### Authentication

Authentication is handled on the system framework level by[`URLCredential`and`URLAuthenticationChallenge`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLAuthenticationChallenge_Class/Reference/Reference.html).

**Supported Authentication Schemes**

- [HTTP Basic](http://en.wikipedia.org/wiki/Basic_access_authentication)
- [HTTP Digest](http://en.wikipedia.org/wiki/Digest_access_authentication)
- [Kerberos](http://en.wikipedia.org/wiki/Kerberos_%28protocol%29)
- [NTLM](http://en.wikipedia.org/wiki/NT_LAN_Manager)

## Advanced usage

> WTKit isbuildon  `NSURLSession` and Foundation URL Loading System . To make the most of this framework, it is recommended that you be familiar with the concepts and capabilities of the underlying networking stack..

**Recommended Reading**

- [URL Loading System Programming Guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html)
- [NSURLSession Class Reference](https://developer.apple.com/library/mac/documentation/Foundation/Reference/NSURLSession_class/Introduction/Introduction.html#//apple_ref/occ/cl/NSURLSession)
- [NSURLCache Class Reference](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLCache_Class/Reference/Reference.html#//apple_ref/occ/cl/NSURLCache)
- [NSURLAuthenticationChallenge Class Reference](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLAuthenticationChallenge_Class/Reference/Reference.html)


#### App Transport Security (ATS)
With the addition of App Transport Security (ATS) in iOS 9, it is possible that using a custom `ServerTrustPolicyManager` with several `ServerTrustPolicy` objects will have no effect. If you continuously see `CFNetwork SSLHandshake failed (-9806)` errors, you have probably run into this problem. Apple's ATS system overrides the entire challenge system unless you configure the ATS settings in your app's plist to disable enough of it to allow your app to evaluate the server trust.

If you run into this problem (high probability with self-signed certificates), you can work around this issue by adding the following to your `Info.plist`.
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
> firstLaunchForBuild This method in the application of multiple times with the effect is the same, as long as the first start,
   Regardless of the number of calls are the first time to start, please rest assured that use

- UIButton
Request the image then caching to the local

```swift

requestButton.setImageWith("url", forState: .Normal,placeHolder: nil)
```
- UIImage

The picture is cut into rounded corners

```swift
let image:UIImage = (self.imageView.image?.imageWithRoundCornerRadius(30))
```
- UIImageView
Request the picture, and cache it locally, the next time you set the image to read the cache

```swift
//set image with a url
imageView.setImageWith("url")

//set hight lighted image with a url,and set a place holder image
imageView.sethighlightedImageWith("url", placeHolder: placeHolderImage)

```
- UIViewController
loading and tip

```swift
//hide loading
self.showLoadingView()

//hide loading
self.hideLoadingView()


//tip at bottom
self.showHudWithTip("热烈欢迎")
```

- UIView
UIView screen shot
```swift
let image:UIImage = self.view.snapShot()//get a snap shot image
let pdf:Data = self.view.pdf()//get a pdf shot
```
- UIScrollView
pull to refresh 
```swift
//closure to refresh
self.tableView.refreshHeader = RefreshHeader.headerWithRefreshing({
            printf("refresh data from internet")
        })

//stop Loading
self.tableView.stopLoading()

//local settings,default is English
tableView.refreshHeader?.setTitle("加载中...", forState: .Loading)
tableView.refreshHeader?.setTitle("下拉刷新", forState: .PullDownToRefresh)
tableView.refreshHeader?.setTitle("松开刷新", forState: .ReleaseToRefresh)
tableView.refreshHeader?.dateStyle = "yyyy-MM-dd"
tableView.refreshHeader?.lastUpdateText = "上次刷新时间"
//refresh image
tableView.refreshHeader?.arrowImageURL = "http://ww4.sinaimg.cn/mw690/47449485jw1f4wq45lqu6j201i02gq2p.jpg"

```
- CALayer

```swift

let image:UIImage =  self.view.layer.snapShot()
//pause animation
self.view.layer.pauseAnimation()
//resume animation
self.view.layer.resumeAnimation()
```


## LICENSE

WTKit is released under the MIT license. See LICENSE for details.
