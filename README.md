# WTKit

WTKit is my swift accumulated experience
## Features
- [x] String to UIColor
- [x] String to URL
- [x] URLRequest to CURL
- [x] Codable to JSON String
- [x] JSON to Codable Model
- [x] Base Hud View(text/indicator)
- [x] Version track
- [x] Load Web Image
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

## Making Codable Requests
WTKit provides a variety of convenience methods for making HTTP requests.

```swift
let task = URLSession.shared.dataTaskWith(request: "https://httpbin.org/get".urlRequest, codable: { (model:Codable) in

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
  "args": {},
  "headers": {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept-Language": "zh-cn",
    "Host": "httpbin.org",
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15",
    "X-Amzn-Trace-Id": "Root=1-5e6b977f-43ebdc40121912f0bb6dc3d0"
  },
  "origin": "123.120.230.73",
  "url": "https://httpbin.org/get"
}
"""
//if in DEBUG Mode,and testData != nil,the simulatedData will take effect
URLSession.shared.dataTaskWith(request: "https://httpbin.org".urlRequest, testData: simData, codable: { (obj:Codable) in

        }) { (data, res, err) in

        }

```

## cURL Command Output

Debug tool
```
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

## ModelMaker

create Codable File from JSON Data
https://github.com/songwentong/ModelMaker
additional Xcode App on Mac,using it to create Codable file Convenience,just copy your json ,edit class name,and press write,you file will create easily
![](https://github.com/songwentong/WTKit/blob/master/images/modelMaker.png)
