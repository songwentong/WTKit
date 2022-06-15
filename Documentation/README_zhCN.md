<a href="https://github.com/songwentong/WTKit/actions?query=workflow%3Abuild"><img src = "https://github.com/songwentong/WTKit/workflows/build/badge.svg?branch=master">
</a>
[![Swift](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6-Orange?style=flat-square)
![Platform](https://img.shields.io/badge/platform-iOS%20macOS%20tvOS%20watchOS-brightgreen)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-Only-brightgreen?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-only-brightgreen?style=flat-square)

# WTKit

WTKit是我积累的经验,我认为WTKit可以帮助您提高开发效率。
## 功能
- [x] Codable 扩展(JSON解析,含类型适配)
- [x] 发出可编码请求
- [x] cURL命令输出
- [x] 用于测试的仿真响应数据
- [x] 转换为UIColor的字符串
- [x] 表格模型
- [x] WTGradientView
- [x] 可编码为JSON字符串
- [x] JSON到可编码模型
- [x] 基本Hud视图(文本/指示器)
- [x] 版本跟踪
- [x] 载入url图片

## UIView + Xib
从nib文件创建UIView(或子类)的实例,当您想在xib文件中重用UIView时,可以使用它,建议您使用UITableViewCell而不是UIVIew,因为它具有contentView,没有文件的所有者问题。
```swift
let myView:MyView = MyView.instanceFromXib()
//从xib文件创建MyView实例
//通常将其用作UITableViewCell子类,以避免文件所有者问题
```

## UIViewController + IB
从Storyboard / nib创建UIViewController实例
```swift
let vc:CustromVC = CustromVC.instanceFromStoryBoard()
//此函数是从Storyboard的根VC创建实例

let vc2:CustromVC = CustromVC.instanceFromNib()
//从nib文件创建实例
```

## 十六进制颜色

```swift
"f".hexColor //白色的UIColor,与"ffffff"相同
"＃3".hexColor //与333333相同
"ff0000".hexColor //红色UIColor
"ff0000".hexCGColor //红色CGColor
```
## 可编码扩展

从Codable 对象创建json数据

```swift
let obj:Codable
打印(obj.jsonString)
//要么
(lldb)po obj.lldbPrint()
//输出将是这样的json
{
  "args":{},
  "origin":"123.120.230.73",
  "url":"https://httpbin.org/get"
}

```

## Codable 扩展(模型创建,数据解析)
#### WTKit 可以根据json字符串创建数据
#### 可类型适配数据解码,WTKit 可以处理 JSONDecoder 的类型错误异常,然后转变成你需要的数据类型,比如你的属性是Int,但是可以接收 String/Double/Int类型的数据, 或者属性是String ,可以接受 String/Double/Int类型的数据
#### Endocable/Decodable 扩展,Decodable 可以直接读取JSON,Encodable 可以转变为 json 字符串
```swift
    func json1() -> String {
        let json1 = """
    {
      "intValue": 3,
      "strValue": "3.8",
      "double": "3.5",
      "intList": [
        1,
        2
      ],
      "flag": true,
      "doubleList": [
        1.1,
        2.2
      ],
      "object": {
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "zh-cn",
        "Host": "httpbin.org",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15",
        "X-Amzn-Trace-Id": "Root=1-5e716637-2f2252cc4747e55326ef4a08"
      },
      "objectList": [
        {
          "id": 145,
          "title": "喜欢你",
          "num": "4",
          "pic": "https://img3.tuwandata.com/uploads/play/9766281560847422.png"
        },
        {
          "id": 148,
          "title": "么么哒",
          "num": "3",
          "pic": "https://img3.tuwandata.com/uploads/play/6851431563789324.png"
        }
      ]
    }
    """
        return json1
    }


    ///Codable模型创建
    ///给出一个class/struct名和json字符串，创建一个对应名字的class/struct
    ///并写入Document目录
    ///model处理了类型异常并转化，
    ///Int类型如果收到了String会自动转化类型，反之亦然
    ///对象类型和其他复杂类型也做了异常处理，不再抛出异常
    func testModelCreate() {
        let maker = WTModelMaker.default
//        maker.needOptionalMark = false
//        maker.useStruct = true
        let className = "TestModel"
        let classCode = maker.createModelWith(className: className, jsonString: json1())
        print(NSHomeDirectory())
//        print(classCode)
        let path = NSHomeDirectory() + "/Documents/" + className + ".swift"
        print(path)
        do {
            try classCode.write(toFile: path, atomically: true, encoding: .utf8)
#if os(macOS)
            let url = path.urlValue
            NSWorkspace.shared.activateFileViewerSelecting([url])
            NSWorkspace.shared.selectFile(path, inFileViewerRootedAtPath: "/")
#else
#endif
        } catch {

        }
    }

     /**
     test model Decode 测试数据解码
     contains type error/key not found  包含了类型异常，字段异常
     Int/Double/String     type error handle and transfer to type 异常处理
     others decode no error throws
     */
    func testDecode() {
        guard let obj2 = TestModel.decodeIfPresent(with: json1().utf8Data) else{
            return
        }
        print(obj2.jsonString)
    }
```

## 发出请求,返回Codable对象
WTKit提供了多种方便的方法来发出HTTP请求。

```swift
public class HttpBin:NSObject,Codable{
    var url:String =""
    var origin:String =""
    enum CodingKeys:String,CodingKey {
        case url ="url"
        origin="origin"
    }
}
let request ="https://httpbin.org/get".urlRequest
let task = WT.dataTaskWith(request:request,
 codable:{(model:HttpBin)in
//模型被解析为可编码实例
        }){(data,res,err)in

        }
task.resume()
```

## 模拟URL响应数据

此功能仅对调试有效
```swift
//模拟数据
let simData =
"""
{
  "origin":"123.120.230.73",
  "url":"https://httpbin.org/get"
}
"""

let req ="https://httpbin.org".urlRequest
//如果处于DEBUG模式,并且testData！= nil
//模拟数据将生效

WT.dataTaskWith(request:req,testData:simData,
  codable:{(obj:HttpBin)in
//在调试模式下,如果不为零,obj将从testData解析
  }){(data,res,err)in

}

```

## cURL命令输出

调试工具
```swift
let request ="https://httpbin.org/get".urlRequest
print(request.printer)
```
或者您可以在lldb中打印它:

```swift
(lldb)po request.printer
```


这应该产生:

```swift
$ curl -v \
-X GET \
-H "Accept-Language: en;q=1.0" \
-H "Accept-Encoding: br;q=1.0, gzip;q=0.9, deflate;q=0.8" \
-H "User-Agent: Demo/1.0 (com.demo.Demo; build:1; iOS 13.0.0) WTKit/1.0" \
"https://httpbin.org/get"
```
![](https://github.com/songwentong/WTKit/blob/master/images/printer.png)

## 模型制作器

从JSON数据创建可编码模型类/结构文件
https://github.com/songwentong/ModelMaker
Mac上的其他Xcode App,使用它来创建Codable文件的便利性,只需复制json,编辑类名,然后按"写入文件",即可轻松创建文件。
它将自动覆盖描述和debugDescription。此功能非常有用,默认设置不会为您打印属性(就像Model:<0x00000f1231>一样),如果您打印obj,它将显示给您,如果您想查看属性值,只需在lldb上打印或打印。
默认情况下使用CodkingKeys建立模型,您可以轻松地重命名地图。
![](https://github.com/songwentong/WTKit/blob/master/images/modelMaker.png)


### 无描述/调试说明
![](https://github.com/songwentong/WTKit/blob/master/images/noDesc.png)
### 带有描述 / 调试说明
![](https://github.com/songwentong/WTKit/blob/master/images/desc.png)
```swift
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




## WTGradientView

一个UIView按住CAGradientView编辑,其属性将在其图层上生效。

```swift
let gview = WTGradientView()
gview.colors = ["f".hexCGColor,"990000".hexCGColor]
gview.locations = [0,1]
gview.startPoint = CGPoint(x:0,y:0.5)
gview.endPoint = CGPoint(x:1,y:0.5)
//它将影响它的CAGradientView自动
```

## 版本跟踪
记录构建历史记录的功能

```swift
func application(_ application:UIApplication,didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey:Any]？)->布尔{
  application.track()// track两次无效
  application.versionHistory()//版本历史
  application.buildHistory()//构建历史
  应用
```
## WT Table Model
这里使用面向对象开发的抽象策略,这也是MVC模式中Model部分的体现。使用面向协议的编程将UITableView描述为Model,这将更加灵活,没有类树的约束。
```swift
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
更多
```swift
//您可以使用此协议来描述某些单元格的更多信息
public extension UITableViewCellDetailModel:UITableViewCellModel {
    var height:CGFloat {get set}
    var didSelectAction:DispatchWorkItem？{get set}
    var willDisplayAction:DispatchWorkItem？{get set}
    var prefetchAction:DispatchWorkItem？{get set}
    var cancelPrefetchingAction:DispatchWorkItem？{get set}
}
```
#### 发送数据。
#### 这些方法适用于所有使用WTTableModel的情况。
```swift
public protocol UITableViewCellModelHolder {
    var model:UITableViewCellModel？{get set}
}
public extension UITableView {
    func dequeueReusableCellModel(withModel模型:UITableViewCellModel,用于indexPath:IndexPath)-> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier:model.reuseIdentifier,for:indexPath)
        如果var c = cell as？ UITableViewCellModelHolder {
            c.model = model
        }
        return cell
    }
}
```

## 本地语言

编辑customBundle捆绑包可以轻松更改本地语言
```swift
//使用英语
Bundle.customBundle = enUS
print("language".customLocalizedString)
//输出将是
//language
print("english".customLocalizedString)
//english
Bundle.customBundle = zhCN
print("language".customLocalizedString)
//输出将是
//语言
print("english".customLocalizedString)
//英语
```


## 安装
### Swift Package Manager
在Xcode 11中,您可以使用Swift Package Manager将WTKit添加到您的项目中。

 - 选择"文件">"Swift软件包">"添加软件包依赖性"。在"选择软件包存储库"对话框中输入https://github.com/songwentong/WTKit.git。
 - 在下一页中,将规则指定为master分支
 - Xcode签出源代码并解析版本后,您可以选择"WTKit"库并将其添加到您的应用程序目标中。
```
https://github.com/songwentong/WTKit.git
```
![](https://github.com/songwentong/WTKit/blob/master/images/swiftPackage.png)
