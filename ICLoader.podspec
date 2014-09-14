Pod::Spec.new do |s|
  s.name          = "ICLoader"
  s.version       = "1.0.0"
  s.summary       = "(yet another) simple frosty loader/HUD."
  s.homepage      = "https://github.com/jasperblues/ICLoader.git"
  s.license       = { :type => 'Apache 2.0'}
  s.authors       = 'Jasper Blues'
  s.source        = { :git => "https://github.com/jasperblues/ICLoader.git", :tag => s.version.to_s }
  s.source_files  = 'ICLoader.{h,m}'
  s.requires_arc  = true
  s.ios.deployment_target = '5.0'
  s.dependency 'FXBlurview'
end
