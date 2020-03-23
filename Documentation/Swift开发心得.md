# Swift心得 
1.Extension给Model扩展
举个例子
```swift
class MyModel:Codable{
var time:TimeInterval
//0 male 1 female
var sex:Int
}
```
```swift
extension MyModel{
func dateStr()->String{
let df = DateFormatter()
let date = Date(time)
return df.stringFromDate(date)
}
func maleColor()->UIColor{
if male == 0{
return UIColor.blueColor
}else{
return UIColor.redColor
}
}
}
```
