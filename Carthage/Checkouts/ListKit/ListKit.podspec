Pod::Spec.new do |s|
  s.name             = "ListKit"
  s.version          = "2.0.0"
  s.summary          = "A libary that helps you build table views without re-inventing the data source"
  s.description      = "A libary that helps you build table views without re-inventing the data source."
  s.homepage         = "https://github.com/Ben-G/ListKit"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = { "Benjamin Encz" => "me@benjamin-encz.de" }
  s.social_media_url = "http://twitter.com/benjaminencz"
  s.source           = { :git => "https://github.com/Ben-G/ListKit.git", :tag => s.version.to_s }

  s.platforms     = { :ios => "8.0" }
  s.requires_arc = true

  s.source_files     = 'ListKit/*.{swift}'

end
