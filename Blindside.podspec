Pod::Spec.new do |s|
  s.name         = "Blindside"
  s.version      = "1.0-alpha"
  s.summary      = "Blindside provides dependency injection capabilities for Objective-C on iOS and OS X"
  s.homepage     = "https://github.com/jbsf/blindside"
  s.license      = 'MIT'
  s.author       = { "JB Steadman" => "jb@pivotallabs.com" }
  s.source       = { :git => "https://github.com/jbsf/blindside.git", :commit => "362b99b97008bd3d46f789803afeb8ef88710ec4" }
  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source_files = 'Deferred', '{Source,Headers}/**/*.{h,m}'
end
