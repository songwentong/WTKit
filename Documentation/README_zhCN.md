<a href="https://github.com/songwentong/WTKit/actions?query=workflow%3Abuild"><img src = "https://github.com/songwentong/WTKit/workflows/build/badge.svg?branch=master">
</a>
[![Platform](https://img.shields.io/cocoapods/p/Alamofire.svg?style=flat)](https://alamofire.github.io/Alamofire)

＃WTKit

WTKit是我积累的经验，我认为WTKit可以帮助您提高开发效率。
## 功能
- [x] 发出可编码请求
- [x] cURL命令输出
- [x] 用于测试的仿真响应数据
- [x] 转换为UIColor的字符串
- [x] 表格模型
- [x] WTGradientView
- [x] 可编码为JSON字符串
- [x] JSON到可编码模型
- [x] 基本Hud视图（文本/指示器）
- [x] 版本跟踪
- [x] 载入网页图片

##发出可编码请求
WTKit提供了多种方便的方法来发出HTTP请求。

```
public class HttpBin：NSObject，Codable{
    var url：String =“”
    var origin：String =“”
    enum CodingKeys：String，CodingKey {
        case url =“ url”
        origin=“origin”
    }
}
let request =“ https://httpbin.org/get".urlRequest
let task = WT.dataTaskWith（request：request，
 codable：{（model：HttpBin）in
//模型被解析为可编码实例
        }）{（data，res，err）in

        }
task.resume（）
```

##模拟响应数据

此功能仅对调试有效
```
//模拟数据
让simData =
“”
{
  “ origin”：“ 123.120.230.73”，
  “ url”：“ https://httpbin.org/get”
}
“”

让req =“ https://httpbin.org” .urlRequest
//如果处于DEBUG模式，并且testData！= nil
//模拟数据将生效

WT.dataTaskWith（request：req，testData：simData，
  codable：{（obj：HttpBin）in
//在调试模式下，如果不为零，obj将从testData解析
  }）{（data，res，err）in

}

```

## cURL命令输出

调试工具
```
let request =“ https://httpbin.org/get".urlRequest
打印（request.printer）
```
或者您可以在lldb中打印它：

```
（lldb）po request.printer
```


这应该产生：

```
$ curl -v \
-X GET \
-H "Accept-Language: en;q=1.0" \
-H "Accept-Encoding: br;q=1.0, gzip;q=0.9, deflate;q=0.8" \
-H "User-Agent: Demo/1.0 (com.demo.Demo; build:1; iOS 13.0.0) WTKit/1.0" \
"https://httpbin.org/get"
```
![](https://github.com/songwentong/WTKit/blob/master/images/printer.png)

##模型制作器

从JSON数据创建可编码模型类/结构文件
https://github.com/songwentong/ModelMaker
Mac上的其他Xcode App，使用它来创建Codable文件的便利性，只需复制json，编辑类名，然后按“写入文件”，即可轻松创建文件。
它将自动覆盖描述和debugDescription。此功能非常有用，默认设置不会为您打印属性（就像Model：<0x00000f1231>一样），如果您打印obj，它将显示给您，如果您想查看属性值，只需在lldb上打印或打印。
默认情况下使用CodkingKeys建立模型，您可以轻松地重命名地图。
![](https://github.com/songwentong/WTKit/blob/master/images/modelMaker.png)


###无描述/调试说明
![](https://github.com/songwentong/WTKit/blob/master/images/noDesc.png)
###带有description / debugDescription
![](https://github.com/songwentong/WTKit/blob/master/images/desc.png)
```
打印（obj）
//要么
（lldb）po obj
/ *
//输出将是
args：debug args_class的说明：
网址：https：//httpbin.org/get
headers：debug headers_class的描述：
接受：text / html，application / xhtml + xml，application / xml; q = 0.9，* / *; q = 0.8
主持人：httpbin.org
用户代理：Mozilla / 5.0（Macintosh; Intel Mac OS X 10_15_3）AppleWebKit / 605.1.15（KHTML，如Gecko）版本/13.0.5 Safari / 605.1.15
接受语言：zh-cn
接受编码：gzip，deflate，br
X-Amzn-Trace-Id：Root = 1-5e6b977f-43ebdc40121912f0bb6dc3d0
起源：123.120.230.73
* /
```

##可编码扩展

从可编码的objec创建json数据

```
let obj：可编码
打印（obj.jsonString）
//要么
（lldb）po obj.lldbPrint（）
//输出将是这样的json
{
  “ args”：{}，
  “ origin”：“ 123.120.230.73”，
  “ url”：“ https://httpbin.org/get”
}

```

##十六进制颜色

```
“ f” .hexColor //白色的UIColor，与“ ffffff”相同
“＃3” .hexColor //与333333相同
“ ff0000” .hexColor //红色UIColor
“ ff0000” .hexCGColor //红色CGColor
```

## WTGradientView

一个UIView按住CAGradientView编辑，其属性将在其图层上生效。

```
让gview = WTGradientView（）
gview.colors = [“ f” .hexCGColor，“ 990000” .hexCGColor]
gview.locations = [0，1]
gview.startPoint = CGPoint（x：0，y：0.5）
gview.endPoint = CGPoint（x：1，y：0.5）
//它将影响它的CAGradientView自动
```

## UINib扩展
UINibReusableCell协议

```
Cell类：UITableViewCell，UINibReusableCell {

}
//自动加载nib文件
let nib：UINib = Cell.nib（）
//单元格，就像它的类名一样
let ReuseID：String = Cell.reuseIdentifier

```

##版本跟踪
记录构建历史记录的功能

```
func application（_ application：UIApplication，didFinishLaunchingWithOptions launchOptions：[UIApplication.LaunchOptionsKey：Any]？）->布尔{
  application.track（）// track两次无效
  application.versionHistory（）//版本历史
  application.buildHistory（）//构建历史
  应用
```
## WT表模型
这里使用面向对象开发的抽象策略，这也是MVC模式中Model部分的体现。使用面向协议的编程将UITableView描述为Model，这将更加灵活，没有类树的约束。
```
//单元格模型
public extension UITableViewCellModel {
    var复用标识符：字符串{获取设置}
    var对象：是吗？{get set}
    var userInfo：[AnyHashable：任何]？{获取设置}
}
//截面模型
public extension UITableViewSectionModel {
    var单元格：[UITableViewCellModel] {获取设置}
}
//表格模型
public extension UITableViewModel {
    var个部分：[UITableViewSectionModel] {获取设置}
}
```
更多
```
//您可以使用此协议来描述某些单元格的更多信息
public extension UITableViewCellDetailModel：UITableViewCellModel {
    var height：CGFloat {get set}
    var didSelectAction：DispatchWorkItem？{get set}
    var willDisplayAction：DispatchWorkItem？{get set}
    var prefetchAction：DispatchWorkItem？{get set}
    var cancelPrefetchingAction：DispatchWorkItem？{get set}
}
```
####发送数据。
####这些方法适用于所有使用WTTableModel的情况。
```
public protocol UITableViewCellModelHolder {
    var model：UITableViewCellModel？{get set}
}
public extension UITableView {
    func dequeueReusableCellModel（withModel模型：UITableViewCellModel，用于indexPath：IndexPath）-> UITableViewCell {
        let cell = dequeueReusableCell（withIdentifier：model.reuseIdentifier，for：indexPath）
        如果var c = cell as？ UITableViewCellModelHolder {
            c.model =模型
        }
        返回单元
    }
}
```
## UIView + Xib
从nib文件创建UIView（或子类）的实例，当您想在xib文件中重用UIView时，可以使用它，建议您使用UITableViewCell而不是UIVIew，因为它具有contentView，没有文件的所有者问题。
```
让myView：MyView = MyView.instanceFromXib（）
//从xib文件创建MyView实例
//通常将其用作UITableViewCell子类，以避免文件所有者问题
```

## UIViewController + IB
从Storyboard / nib创建UIViewController实例
```
让vc：CustromVC = CustromVC.instanceFromStoryBoard（）
//此函数是从Storyboard的根VC创建实例

让vc2：CustromVC = CustromVC.instanceFromNib（）
//从nib文件创建实例
```
##本地经理

编辑customBundle捆绑包可以轻松更改本地语言
```
//使用英语
let lang =“ language” .customLocalizedString
print（“ language” .customLocalizedString）
//输出将是
//语言
print（“ english” .customLocalizedString）
//英语
Bundle.customBundle = zhCN
print（“ language” .customLocalizedString）
//输出将是
//语言
print（“ english” .customLocalizedString）
//英语
```


##安装
### Swift Package Manager
在Xcode 11中，您可以使用Swift Package Manager将Kingfisher添加到您的项目中。
 -选择“文件”>“ Swift软件包”>“添加软件包依赖性”。在“选择软件包存储库”对话框中输入https://github.com/songwentong/WTKit.git。
 -在下一页中，将规则指定为master分支
 -Xcode签出源代码并解析版本后，您可以选择“ WTKit”库并将其添加到您的应用程序目标中。
```
https://github.com/songwentong/WTKit.git
```
![](https://github.com/songwentong/WTKit/blob/master/images/swiftPackage.png)
