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
 #fir login 4654564515345664546465
 #fir publish ~/Desktop/Stark.ipa
 #蒲公英上传
 #curl -F "file=@/tmp/example.ipa" -F "uKey=b736b5b4b9faf418032c635e5e4429c4" -F "_api_key=72c4cc26d7572ce9814234b6da54083d" https://upload.pgyer.com/apiv1/app/upload
 xcrun altool --validate-app -f $XCS_PRODUCT -u 275712575@qq.com -p swtpwd
 xcrun altool --upload-app -f $XCS_PRODUCT -u 275712575@qq.com -p swtpwd
