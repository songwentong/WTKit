
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
NSOperationQueue.globalQueue { 
            print("current is  global queue")
        }
NSOperationQueue.gotoMainQueue { 
            print("current is main queue")
        }
NSOperationQueue.userInteractive { 
            print("current queue is global queue priority : userInteractive")
        }
NSOperationQueue.background { 
            print("current queue is global queue priority : background")
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
public func numberFor(unit:NSCalendarUnit)->Int


let date = NSDate()
print("year:  \(date.numberFor(.Year)) month:\(date.numberFor(.Month)) day:\(date.numberFor(.Month))")
        
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
        
//finish refresh        
self.tableView.finishRefresh()
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

