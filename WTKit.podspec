Pod::Spec.new do |s|
  s.name        = "WTKit"
  s.version     = "1.0"
  s.summary     = "WTKit"
  s.homepage    = "https://github.com/swtlovewtt/WTKit"
  s.license     = { :type => "MIT" }
  s.authors     = { "sonogwentong" => "275712575@qq.com" }

  s.requires_arc = true
  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source   = { :git => "https://github.com/swtlovewtt/WTKit.git", :tag => s.version }
  s.source_files = "WTKit/WTKit/*.swift"
end
