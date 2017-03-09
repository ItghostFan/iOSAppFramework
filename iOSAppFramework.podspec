#
# Be sure to run `pod lib lint iOSAppFramework.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iOSAppFramework'
  s.version          = '0.1.5'
  s.summary          = 'Source iOSAppFramework is a basic iOS App framework for App development.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ItghostFan/iOSAppFramework'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ItghostFan' => 'itghostfan@163.com' }
  s.source           = { :git => 'https://github.com/ItghostFan/iOSAppFramework.git', :tag => '0.1.5' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  #s.source_files = 'iOSAppFramework/Classes/**/*'

  s.subspec 'Framework' do |framework|
    framework.subspec 'Foundation' do |foundation|
    foundation.source_files = 'iOSAppFramework/Classes/Framework/Foundation/*.{h,m}'
    end
    framework.subspec 'UIKit' do |uikit|
    uikit.source_files = 'iOSAppFramework/Classes/Framework/UIKit/*.{h,m}'
    end

    framework.dependency 'Masonry'
    framework.dependency 'AFNetworking', '~> 2.3'
    framework.dependency 'JSONModel', '~> 1.7.0'
    framework.dependency 'FMDB/SQLCipher'
    framework.dependency 'SDWebImage', '~> 3.7.5'
  end

  s.subspec 'iOS' do |ios|
    ios.subspec 'Foundation' do |foundation|
    foundation.source_files = 'iOSAppFramework/Classes/iOS/Foundation/*.{h,m}'
    end
    ios.subspec 'UIKit' do |uikit|
    uikit.source_files = 'iOSAppFramework/Classes/iOS/UIKit/*.{h,m}'
    end
  end

  s.subspec 'ThirdParty' do |thirdparty|
    thirdparty.subspec 'ReactiveCocoa' do |reactivecocoa|
    reactivecocoa.source_files = 'iOSAppFramework/Classes/ThirdParty/ReactiveCocoa/*.{h,m}'
    end
    thirdparty.dependency 'ReactiveCocoa', '~> 2.5'
  end

  # s.resource_bundles = {
  #   'iOSAppFramework' => ['iOSAppFramework/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'CocoaAsyncSocket'
end
