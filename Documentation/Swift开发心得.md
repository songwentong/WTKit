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
