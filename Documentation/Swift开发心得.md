
### App启动过程
1. 解析Info.plist
2. Mach-O加载
3. 程序执行

- 详细描述
1. 加载dyld到App进程
2. 加载动态库（包括所依赖的所有动态库）
3. Rebase
4. Bind
5. 初始化Objective C Runtime
6. 其它的初始化代码

- 在Xcode中，可以通过设置环境变量来查看App的启动时间，DYLD_PRINT_STATISTICS和DYLD_PRINT_STATISTICS_DETAILS。

### 启动优化
1. 移除不需要用到的动态库
2. 移除不需要用到的类
3. 合并功能类似的类和扩展
4. 尽量避免在+load方法里执行的操作，可以推迟到+initialize方法中。


### 如何抓https包
1. 将Charles的根证书(Charles Root Certificates)安装到Mac上。
2. 步骤二：Mac信任Charles的根证书。
3. 步骤三：将Charles证书安装到移动设备上。
4. 步骤四：移动设备信任Charles证书。
5. 步骤五：Charles设置“Enable SSL Proxying”

### 如何反抓包
使用自签证书 ssl-pinning模式
客户端本地做证书校验,并且设置不仅仅校验公钥,设置完整的正式校验模式。

这么做为什么是安全的？了解HTTPS的人都知道，整个验证体系中，最核心的实际上是服务器的私钥。私钥永远，永远也不会离开服务器，或者以任何形式向外传输。私钥和公钥是配对的，如果事先在客户端预留了公钥，只要服务器端的公钥和预留的公钥一致，实际上就已经可以排除中间人攻击了。

https双向认证
### 大量数据刷新的处理


### swift protocol 和OC protocol不同
1. OC支持可选方法
2.
### swift 如何保证单例

### 图片压缩
1. 可以用系统方法,提供缩放比
2. 可以减少颜色位数,比如24位的图改为8位


### Swift心得
1.Extension给Model扩展
举个例子
```swift
class MyModel:Codable{
var time:TimeInterval
//0 male 1 female
var sex:Int
var subscribed:Int
}
```
```swift
extension MyModel{
  //根据时间戳给出字符串
func dateStr()->String{
let df = DateFormatter()
let date = Date(time)
return df.stringFromDate(date)
}
///根据性别给出图片
func maleColor()->UIColor{
if sex == 0{
return "male".namedUIImage
}else{
return "female".namedUIImage
}
}

///根据字段给出字符串
func subscribeText()-> String{
  return "\(subscribed)" + "粉丝".localText
}
}
```
