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

## cURL Command Output

Debug tool
```
print(request.printer)

```

This should produce:

```
$ curl -v \
-X GET \
-H "Accept-Language: en;q=1.0" \
-H "Accept-Encoding: br;q=1.0, gzip;q=0.9, deflate;q=0.8" \
-H "User-Agent: Demo/1.0 (com.demo.Demo; build:1; iOS 13.0.0) Alamofire/1.0" \
"https://httpbin.org/get"
```
