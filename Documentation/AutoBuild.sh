#xcode server build shell
 git pull
 cd ..
 pod update
 agvtool new-version -all $XCS_INTEGRATION_NUMBER
 #release
 #build and archive,use for not Xcode server
 #xcodebuild archive -workspace Stark.xcworkspace -scheme Stark -configuration Release -archivePath ~/Desktop/Stark.xcarchive
 #xcodebuild -exportArchive -archivePath ~/Desktop/Stark.xcarchive -exportPath ~/Desktop/Stark.ipa -exportOptionsPlist ~/Desktop/ExportOptions.plist
 #upload fir ifneeded,using fir-cli
 #fir publish ~/Desktop/Stark.ipa
 xcrun altool --validate-app -f $XCS_PRODUCT -u 275712575@qq.com -p swtpwd
 xcrun altool --upload-app -f $XCS_PRODUCT -u 275712575@qq.com -p swtpwd
