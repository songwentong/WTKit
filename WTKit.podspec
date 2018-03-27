Pod::Spec.new do |s|
  s.name = 'WTKit'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'Elegant HTTP Networking in Swift'
  s.homepage = 'https://github.com/swtlovewtt/WTKit'
  s.authors = { '宋文通' => 'https://github.com/swtlovewtt/WTKit' }
  s.source = { :git => 'https://github.com/swtlovewtt/WTKit.git', :tag => s.version }
  s.swift_version = '4.0'

  s.ios.deployment_target = '10.0'
# s.osx.deployment_target = '10.10'
# s.tvos.deployment_target = '9.0'
# s.watchos.deployment_target = '2.0'

  s.source_files = 'WTKit/*.swift'
end
