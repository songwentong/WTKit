fun(){
#自动打包脚本，赠予有缘人
#所有kkkkkkkkkkkkkkkkkkkkkk这种字符串换成你的key
#profile path
#~/Library/MobileDevice/Provisioning\ Profiles
#xcode server build shell
echo "appName build begin">>~/Desktop/buildLog
date>>~/Desktop/buildLog
t1=$(date +%s)
#revert build change
cd ~/Downloads/MyApp
git add .
git reset --hard

#更新子模块
cd components/CocosGame/jsb-default
git pull --rebase
#更新private模块
cd ~/Downloads/DianDian_PrivatePods
git pull --rebase
git lfs pull

#更新主工程
cd ~/Downloads/MyApp
git pull --rebase
pod install


#update build version
value=$(<~/Desktop/build)
value=$((value+1))
agvtool new-version -all $value
echo "$value"
echo $value>~/Desktop/build
#写一下buildnumber
echo "build number">>~/Desktop/buildLog
echo $value>>~/Desktop/buildLog

#build
xcodebuild archive -workspace MyApp.xcworkspace -scheme MyApp -configuration Release -destination generic/platform=iOS -archivePath ~/Desktop/MyApp.xcarchive
cd cerAndProVision
xcodebuild -exportArchive -archivePath ~/Desktop/MyApp.xcarchive -exportPath ~/Desktop/MyApp -exportOptionsPlist ReleaseExportOptions.plist
#upload to appStore
cd ~/Desktop/MyApp
#xcrun altool --validate-app --type ios -f [APPName].ipa -u 275712575@qq.com -p xxx
xcrun altool --upload-app --type ios -f [APPName].ipa -u 275712575@qq.com -p xxx
date
#bugly 符号表上传
#API Key
#kkkkkkkkkkkkkkkkkkkkkkkkkkkk
#User Key
#kkkkkkkkkkkkkkkkkkkkkkkkkkkk
cd ~/Desktop/MyApp.xcarchive
zip -r dSYMs.zip dSYMs
zip -r BCSymbolMaps.zip BCSymbolMaps
#App ID
#kkkkkkkkkkkkkkkkkkkkkkkkkkkk
#App Key
#kkkkkkkkkkkkkkkkkkkkkkkkkkkk
#curl -k "https://api.bugly.qq.com/openapi/file/upload/symbol?app_key=eb92bcfc-62b5-4c2a-9ded-8f29d239b917&app_id=30ce33ac24" --form "api_version=1" --form "app_id=kkkkkkkkkkkkkkkkkkkkkkkkkkkk" --form "app_key=kkkkkkkkkkkkkkkkkkkkkkkkkkkk" --form "symbolType=2"  --form "bundleId=com.WTKit.project" --form "productVersion=2.4.2" --form "channel=xxx" --form "fileName=dSYMs.zip" --form "file=@dSYMs.zip" --verbose
#curl -k "https://api.bugly.qq.com/openapi/file/upload/symbol?app_key=eb92bcfc-62b5-4c2a-9ded-8f29d239b917&app_id=30ce33ac24" --form "api_version=1" --form "app_id=kkkkkkkkkkkkkkkkkkkkkkkkkkkk" --form "app_key=kkkkkkkkkkkkkkkkkkkkkkkkkkkk" --form "symbolType=2"  --form "bundleId=com.WTKit.project" --form "productVersion=2.4.2" --form "fileName=BCSymbolMaps.zip" --form "file=@BCSymbolMaps.zip" --verbose

#蒲公英上传
#curl -F "file=@/tmp/example.ipa" -F "uKey=kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk" -F "_api_key=kkkkkkkkkkkkkkkkkkkkkkkk" https://upload.pgyer.com/apiv1/app/upload
#java -jar buglySymboliOS.jar -appid kkkkkkkkkkkkkkkkkkkkkkkkkkkk  -appkey kkkkkkkkkkkkkkkkkkkkkkkkkkkk -bundleid com.abc.abcabc -version 2.4.2 -platform IOS -inputSymbol dSYMs


#FIR.IM上传
#curl -F xxx -F fir.com


t2=$(date +%s)
t3='use time: '$((t2-t1))' seconds'
echo $t3
echo "appName build complete">>~/Desktop/buildLog
date>>~/Desktop/buildLog
}
fun
#下面这个解注释就可以定时运行
#while true; do
#t4=86400
#t5=$((t4-t3))
#echo $t6
#    sleep $t5;
#        fun
#done
