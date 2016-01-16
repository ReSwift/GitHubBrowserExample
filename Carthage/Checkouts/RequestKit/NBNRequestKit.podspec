Pod::Spec.new do |s|
  s.name             = "NBNRequestKit"
  s.version          = "0.2.1"
  s.summary          = "Networking library for OctoKit.swift"
  s.homepage         = "https://github.com/nerdishbynature/RequestKit"
  s.license          = 'MIT'
  s.author           = { "Piet Brauer" => "piet@nerdishbynature.com" }
  s.source           = { :git => "https://github.com/nerdishbynature/RequestKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pietbrauer'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.module_name     = "RequestKit"
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'RequestKit/*.swift'
end
