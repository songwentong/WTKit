# Swift心得
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
///根据性别给出颜色
func maleColor()->UIColor{
if male == 0{
return UIColor.blueColor
}else{
return UIColor.redColor
}
}

///根据字段给出字符串
func subscribeText()-> String{
  return "\(subscribed)" + "粉丝".localText
}
}
```
