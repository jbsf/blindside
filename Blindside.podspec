Pod::Spec.new do |s|
  s.name         = "Blindside"
  s.version      = "1.2.0"
  s.summary      = "Blindside provides dependency injection capabilities for Objective-C on iOS and OS X"
  s.homepage     = "https://github.com/jbsf/blindside"
  s.license      = 'MIT'
  s.author       = { "JB Steadman" => "jb@pivotallabs.com" }
  s.source       = { :git => "https://github.com/jbsf/blindside.git", :tag => "v1.2.0" }
  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.watchos.deployment_target = '2.0'

  if s.respond_to?(:tvos)
    s.tvos.deployment_target = '9.0'
  end

  s.source_files = "{Source,Headers}/**/*.{h,m}"
  s.public_header_files = "Headers/Public/*.h"
end
