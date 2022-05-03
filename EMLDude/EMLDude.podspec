Pod::Spec.new do |spec|
  spec.name               = "EMLDude"
  spec.version            = "0.0.1-dev"
  spec.summary            = "EMLDude can help with eml files"
  spec.homepage           = "https://github.com/makhutin/EMLDude"
  spec.license            = "MIT"
  spec.author             = { "Aleksey Makhutin" => "mahutin@me.com" }
  spec.social_media_url   = "https://telegram.me/makhutin"

  spec.ios.deployment_target = "9.0"
  spec.osx.deployment_target = "10.10"

  spec.source       = { :git => "https://github.com/makhutin/EMLDude.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*.{swift,h,m}"
  spec.public_header_files = "Sources/**/*.h"

  spec.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/**/*.{swift,h,m}'
  end  
end
