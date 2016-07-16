Pod::Spec.new do |s|
  s.name             = "NBNRequestKit"
  s.version          = "0.3.0"
  s.summary          = "Networking library for OctoKit.swift"
  s.homepage         = "https://github.com/nerdishbynature/RequestKit"
  s.license          = 'MIT'
  s.author           = { "Piet Brauer" => "piet@nerdishbynature.com" }
  s.source           = { :git => "https://github.com/nerdishbynature/RequestKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pietbrauer'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.module_name     = "RequestKit"
  s.requires_arc = true
  s.source_files = 'RequestKit/*.swift'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
end
