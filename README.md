<a href="https://github.com/songwentong/WTKit/actions?query=workflow%3Abuild"><img src = "https://github.com/songwentong/WTKit/workflows/build/badge.svg?branch=master">
</a>
[![Platform](https://img.shields.io/cocoapods/p/Alamofire.svg?style=flat)](https://alamofire.github.io/Alamofire)

# WTKit

WTKit is my swift accumulated experience,I think WTKit could help you to improve development efficiency.
## Features
- [x] Making Codable Requests
- [x] cURL Command Output
- [x] Simulation response data for test
- [x] String to UIColor
- [x] Table Model
- [x] WTGradientView
- [x] Codable to JSON String
- [x] JSON to Codable Model
- [x] Base Hud View(text/indicator)
- [x] Version track
- [x] Load Web Image

## Making Codable Requests
WTKit provides a variety of convenience methods for making HTTP requests.

```swift
public class HttpBin:NSObject, Codable {
    var url:String = ""
    var origin:String = ""
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case origin = "origin"
    }
}
let request = "https://httpbin.org/get".urlRequest
let task = WT.dataTaskWith(request:request,
 codable: { (model:HttpBin) in
//model is parsed  Codable instance
        }) { (data, res, err) in

        }
task.resume()
```

## simulation response data

this feature is only effect on DEBUG
```
//Simulation data
let simData =
"""
{
  "origin": "123.120.230.73",
  "url": "https://httpbin.org/get"
}
"""

let req = "https://httpbin.org".urlRequest
//if in DEBUG Mode,and testData != nil
//the simulatedData will take effect

WT.dataTaskWith(request: req, testData: simData,
  codable: { (obj:HttpBin) in
//in debug mode ,obj will parse from testData if not nil
  }) { (data, res, err) in

}

```

## cURL Command Output

Debug tool
```
let request = "https://httpbin.org/get".urlRequest
print(request.printer)
```
or you can print it in lldb:

```
(lldb) po request.printer
```


This should produce:

```
$ curl -v \
-X GET \
-H "Accept-Language: en;q=1.0" \
-H "Accept-Encoding: br;q=1.0, gzip;q=0.9, deflate;q=0.8" \
-H "User-Agent: Demo/1.0 (com.demo.Demo; build:1; iOS 13.0.0) WTKit/1.0" \
"https://httpbin.org/get"
```
![](https://github.com/songwentong/WTKit/blob/master/images/printer.png)

## Model Maker

create Codable model class/struct File from JSON Data
https://github.com/songwentong/ModelMaker
additional Xcode App on Mac,using it to create Codable file Convenience,just copy your json ,edit class name,and press 'Write file',your file will create easily.
and it will over write description and debugDescription automatic. this feature is very useful,swift default won't print properties for you(just like Model:<0x00000f1231>),if you print obj it will show you,if you want to see property values,just print it at lldb or print it.
model using CodkingKeys by default,you can rename map easily.
![](https://github.com/songwentong/WTKit/blob/master/images/modelMaker.png)


### without description/debugDescription
![](https://github.com/songwentong/WTKit/blob/master/images/noDesc.png)
### with description/debugDescription
![](https://github.com/songwentong/WTKit/blob/master/images/desc.png)
```
print(obj)
//or
(lldb) po obj
/*
//output will be
args:debugDescription of args_class:
url:https://httpbin.org/get
headers:debugDescription of headers_class:
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Host:httpbin.org
User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15
Accept-Language:zh-cn
Accept-Encoding:gzip, deflate, br
X-Amzn-Trace-Id:Root=1-5e6b977f-43ebdc40121912f0bb6dc3d0
origin:123.120.230.73
*/
```

## Encodable extension

create json data from encodable objec

```
let obj:Encodable
print(obj.jsonString)
//or
(lldb) po obj.lldbPrint()
//output will be json like this
{
  "args": {},
  "origin": "123.120.230.73",
  "url": "https://httpbin.org/get"
}

```

## String hex color

```
"f".hexColor //white UIColor,it same as "ffffff"
"#3".hexColor //same as 333333
"ff0000".hexColor//red UIColor
"ff0000".hexCGColor//red CGColor
```

## WTGradientView

An UIView hold CAGradientView edit it's property will take effect on it's layer.

```
let gview = WTGradientView()
gview.colors = ["f".hexCGColor, "990000".hexCGColor]
gview.locations = [0, 1]
gview.startPoint = CGPoint(x: 0, y: 0.5)
gview.endPoint = CGPoint(x: 1, y: 0.5)
//it will effect on it's CAGradientView automatic
```

## UINib extension
UINibReusableCell protocol

```
class Cell:UITableViewCell,UINibReusableCell{

}
//auto load it's nib file
let nib:UINib = Cell.nib()
//Cell,like it's class name
let reuseID:String = Cell.reuseIdentifier

```

## Version Track
feature to log build history

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  application.track()//track twice no effect
  application.versionHistory()//version history
  application.buildHistory()//build history
  application.isFirstLaunchForBuild//check is first build
}

```

## Table Model
The abstract strategy for object-oriented development is used here, which is also the embodiment of the Model part in the MVC pattern.using Protocol oriented programming to describe UITableView as a Model,this will be more flexible,no class tree's constraint.
```
//cell model
public protocol UITableViewCellModel{
    var reuseIdentifier: String{get set}
    var object: Any?{get set}
    var userInfo: [AnyHashable : Any]?{get set}
}
//section model
public protocol UITableViewSectionModel {
    var cells:[UITableViewCellModel]{get set}
}
//table model
public protocol UITableViewModel {
    var sections:[UITableViewSectionModel]{get set}
}
```
more
```
//you can use this protocol to describe some Cells more info
public protocol UITableViewCellDetailModel:UITableViewCellModel {
    var height:CGFloat{get set}
    var didSelectAction:DispatchWorkItem?{get set}
    var willDisplayAction:DispatchWorkItem?{get set}
    var prefetchAction:DispatchWorkItem?{get set}
    var cancelPrefetchingAction:DispatchWorkItem?{get set}
}
```
send data
```
public protocol UITableViewCellModelHolder {
    var model:UITableViewCellModel?{get set}
}
public extension UITableView{
    func dequeueReusableCellModel(withModel model:UITableViewCellModel, for indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: model.reuseIdentifier, for: indexPath)
        if var c = cell as? UITableViewCellModelHolder{
            c.model = model
        }
        return cell
    }
}
```
## UIView + Xib
create UIView(or subclass) from nib
```
let myView:MyView = MyView.instanceFromXib()
//create MyView instance from xib file
//usually use it as UITableViewCell sub class to avoid file owner issue
```

## UIViewController + IB
create UIViewController instance from storyboard/nib
```
let vc:CustromVC = CustromVC.instanceFromStoryBoard()
//this func is create instance from you Storyboard's root VC

let vc2:CustromVC = CustromVC.instanceFromNib()
//create instance from nib file
```
## Local Manager

edit customBundle of Bundle can change local language easily
```
//using english
let lang = "language".customLocalizedString
print("language".customLocalizedString)
//output will be
//language
print("english".customLocalizedString)
//english
Bundle.customBundle = zhCN
print("language".customLocalizedString)
//output will be
//语言
print("english".customLocalizedString)
//英语
```


## Installation
### swift package manager
From Xcode 11, you can use Swift Package Manager to add Kingfisher to your project.
 - Select File > Swift Packages > Add Package Dependency. Enter https://github.com/songwentong/WTKit.git in the "Choose Package Repository" dialog.
 - In the next page, specify the  rule as master branch
 - After Xcode checking out the source and resolving the version, you can choose the "WTKit" library and add it to your app target.
```
https://github.com/songwentong/WTKit.git
```
![](https://github.com/songwentong/WTKit/blob/master/images/swiftPackage.png)
