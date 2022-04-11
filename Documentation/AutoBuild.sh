#自动打包脚本，赠予有缘人
#所有kkkkkkkkkkkkkkkkkkkkkk这种字符串换成你的key
#xcode server build shell
t1=$(date +%s)
#更新子模块
cd ~/Downloads/TuwanApp
cd components/CocosGame/jsb-default
git pull --rebase
#更新private模块
cd ../../../../DianDian_PrivatePods
git pull --rebase
git lfs pull

#更新主工程
cd ../TuwanApp
git add .
git reset --hard
git pull --rebase
pod install


#update build version
value=$(<~/Desktop/build)
value=$((value+1))
agvtool new-version -all $value
echo "$value"
echo $value>~/Desktop/build

#build
xcodebuild archive -workspace TuWanApp.xcworkspace -scheme TuWanApp -configuration Release -archivePath ~/Desktop/TuWanApp.xcarchive
cd cerAndProVision
xcodebuild -exportArchive -archivePath ~/Desktop/TuWanApp.xcarchive -exportPath ~/Desktop/TuWanApp -exportOptionsPlist ReleaseExportOptions.plist


#upload to appStore
cd ~/Desktop/TuWanApp
xcrun altool --validate-app --type ios -f [APPName].ipa -u 275712575@qq.com -p xxx
xcrun altool --upload-app --type ios -f [APPName].ipa -u 275712575@qq.com -p xxx
date
#bugly 符号表上传
#API Key
#kkkkkkkkkkkkkkkkkkkkkkkkkkkk
#User Key
#kkkkkkkkkkkkkkkkkkkkkkkkkkkk
cd ~/Desktop/TuWanApp.xcarchive
zip -r dSYMs.zip dSYMs
zip -r BCSymbolMaps.zip BCSymbolMaps
#App ID
#kkkkkkkkkkkkkkkkkkkkkkkkkkkk
#App Key
#kkkkkkkkkkkkkkkkkkkkkkkkkkkk
#curl -k "https://api.bugly.qq.com/openapi/file/upload/symbol?app_key=eb92bcfc-62b5-4c2a-9ded-8f29d239b917&app_id=30ce33ac24" --form "api_version=1" --form "app_id=kkkkkkkkkkkkkkkkkkkkkkkkkkkk" --form "app_key=kkkkkkkkkkkkkkkkkkkkkkkkkkkk" --form "symbolType=2"  --form "bundleId=com.tuwan.diandian" --form "productVersion=2.4.2" --form "channel=xxx" --form "fileName=dSYMs.zip" --form "file=@dSYMs.zip" --verbose
#curl -k "https://api.bugly.qq.com/openapi/file/upload/symbol?app_key=eb92bcfc-62b5-4c2a-9ded-8f29d239b917&app_id=30ce33ac24" --form "api_version=1" --form "app_id=kkkkkkkkkkkkkkkkkkkkkkkkkkkk" --form "app_key=kkkkkkkkkkkkkkkkkkkkkkkkkkkk" --form "symbolType=2"  --form "bundleId=com.tuwan.diandian" --form "productVersion=2.4.2" --form "fileName=BCSymbolMaps.zip" --form "file=@BCSymbolMaps.zip" --verbose

#蒲公英上传
#curl -F "file=@/tmp/example.ipa" -F "uKey=kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk" -F "_api_key=kkkkkkkkkkkkkkkkkkkkkkkk" https://upload.pgyer.com/apiv1/app/upload
#java -jar buglySymboliOS.jar -appid kkkkkkkkkkkkkkkkkkkkkkkkkkkk  -appkey kkkkkkkkkkkkkkkkkkkkkkkkkkkk -bundleid com.abc.abcabc -version 2.4.2 -platform IOS -inputSymbol dSYMs


t2=$(date +%s)
t3='use time: '$((t2-t1))' seconds'
echo $t3

#我是宋文通，欢迎交流275712575@qq.com
