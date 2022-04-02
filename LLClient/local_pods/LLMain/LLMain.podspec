#
# Be sure to run `pod lib lint LLMain.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LLMain'
  s.version          = '0.1.0'
  s.summary          = 'A short description of LLMain.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lilu/LLMain'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lilu' => 'chujunhe1234@163.com' }
  s.source           = { :git => 'https://github.com/lilu/LLMain.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = ['LLMain/Classes/**/*']
  #s.static_framework = true
  #s.xcconfig = { 'DEFINES_MODULE' => 'YES' }
  #s.swift_version = '5.1'
  #s.requires_arc = true
  
  # s.resource_bundles = {
  #   'LLMain' => ['LLMain/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'LLCommon'
  s.dependency 'LLNetwork'
  s.dependency 'LLAccount'
  s.dependency 'SnapKit'
end
