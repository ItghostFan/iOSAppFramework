#
# Be sure to run `pod lib lint iOSAppFramework.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iOSAppFramework'
  s.version          = '0.2.11'
  s.summary          = 'App framework source tools.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Source iOSAppFramework is a basic iOS App framework for App development.
                       DESC

  s.homepage         = 'https://github.com/ItghostFan/iOSAppFramework'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ItghostFan' => 'itghostfan@163.com' }
  s.source           = { :git => 'https://github.com/ItghostFan/iOSAppFramework.git', :tag => '0.2.11' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
#s.osx.deployment_target = '10.9'

#s.source_files = 'iOSAppFramework/Classes/**/*'

#s.source_files = 'iOSAppFramework/Classes/**/**/*.h'

  s.default_subspec = 'Framework'
  s.subspec 'Framework' do |framework|
    framework.source_files = 'iOSAppFramework/Classes/Framework/**/*.{h,m}'
    framework.dependency 'iOSAppFramework/iOS'
  end

  s.subspec 'iOS' do |ios|
    ios.source_files = 'iOSAppFramework/Classes/iOS/**/*.{h,m}'
  end


  s.dependency 'Masonry', '~> 1.0.2'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'iOSRunTime'
  s.dependency 'iOSThirdPartyTrap'
  s.dependency 'JSONModel', '~> 1.7.0'
  s.dependency 'FMDB/SQLCipher', '~> 2.7.2'
  s.dependency 'SDWebImage', '~> 4.0.0'
  s.dependency 'ReactiveCocoa', '~> 2.5'

  # s.resource_bundles = {
  #   'iOSAppFramework' => ['iOSAppFramework/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'CocoaAsyncSocket'
end
