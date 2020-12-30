Pod::Spec.new do |s|
  s.name          = "ICLoader"
  s.version       = "2.0.2"
  s.summary       = "(yet another) simple frosty loader/HUD. Now in Swift."
  s.homepage      = "https://github.com/jasperblues/ICLoader.git"
  s.license       = { :type => 'Apache 2.0'}
  s.authors       = 'Jasper Blues'
  s.source        = { :git => "https://github.com/jasperblues/ICLoader.git", :tag => s.version.to_s }
  s.source_files  = '*.swift'
  s.requires_arc  = true
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.1'
  s.dependency 'NanoFrame'
end
