
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
- NSData
```swift
//parse json
public func jsonValue()->(AnyObject?,NSError?)

let json = data?.jsonValue()
let jsonObject:AnyObject? = json?.0
print(json?.0)
let error:NSError? = json?.1
print(json?.1)


//parse json
public func parseJSON(block:(AnyObject,NSError?)->Void)
data?.parseJSON({ (obj, error) in
            print(obj)
            print(error)
        })
```
- NSURLSession 
```swift
//create a request and start 
//optional parameters: method,parameters,headers
NSURLSession.dataTaskWith("url", completionHandler: { (data, response, error) in
                
            })
```
- NSURLRequest 
```swift
//create a request instance
//optional parameters: method,parameters,headers
let request:NSMutableURLRequest? = NSURLRequest.request("url", method: "GET", parameters: nil)
```

- NSOperationQueue
```swift
        NSOperationQueue.main {
            let thread = NSThread.currentThread()
            print("main:\(thread) threadPriority:\(thread.threadPriority)")
            //main thread
        }
        NSOperationQueue.background {
            let thread = NSThread.currentThread()
            print("background:\(thread) threadPriority:\(thread.threadPriority)")
        }
        NSOperationQueue.userInteractive {
            let thread = NSThread.currentThread()
            print("userInteractive:\(thread) threadPriority:\(thread.threadPriority)")
            //separate thread
        }
        NSOperationQueue.globalQueue {
            let thread = NSThread.currentThread()
            print("globalQueue:\(thread) threadPriority:\(thread.threadPriority)")
            //separate thread
        }
/*
userInteractive:<NSThread: 0x7ffb83d6ec50>{number = 2, name = (null)} threadPriority:0.5
background:<NSThread: 0x7ffb83dc79e0>{number = 4, name = (null)} threadPriority:0.0
globalQueue:<NSThread: 0x7ffb83c42d20>{number = 3, name = (null)} threadPriority:0.5
main:<NSThread: 0x7ffb83c02030>{number = 1, name = main} threadPriority:0.758064516129032

*/
```
- String
```swift
let string = "swift"
print(string.length)//5
```
- NSDate
```swift
// Get just one calendar unit value
public func date.numberForComponent(unit:NSCalendarUnit)->Int


let date = NSDate()
print("year:\(date.numberForComponent(.Year)) month:\(date.numberForComponent(.Month)) day:\(date.numberForComponent(.Day))")
//year:2016 month:6 day:15
        
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


//record current version
//note:call this method at application did finish launching
UIApplication.track()

//check current version is first launch ever
if UIApplication.sharedApplication().isFirstLaunchEver {
            print("is first launch for build")
        }else{
            print("not first launch for build")
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

