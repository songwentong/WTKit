Pod::Spec.new do |s|
  s.name        = "WTKit"
  s.version     = "1.0"
  s.summary     = "WTKit"
  s.homepage    = "https://github.com/swtlovewtt/WTKit"
  s.license     = { :type => "MIT" }
  s.authors     = { "sonogwentong" => "275712575@qq.com" }

  s.requires_arc = true
  s.ios.deployment_target = "8.0"
  s.source   = { :git => "https://github.com/swtlovewtt/WTKit.git", :tag => s.version }
  s.source_files = "WTKit/WTKit/*.swift"
end
