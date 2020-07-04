#
# Be sure to run `pod lib lint HLClock.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HLClock'
  s.version          = '0.3.0'
  s.summary          = 'Hybrid Logical Clocks for iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Hybrid Logical Clocks enable causal ordering of events within a distributed system with imperfect clocks.
See: http://muratbuffalo.blogspot.com/2014/07/hybrid-logical-clocks.html
                       DESC

  s.homepage         = 'https://github.com/opentable/HLClock'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Stephen Spalding' => 'sspalding@opentable.com' }
  s.source           = { :git => 'https://github.com/opentable/HLClock.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'HLClock/Classes/**/*'

  s.swift_version = '5.0'
  
  # s.resource_bundles = {
  #   'HLClock' => ['HLClock/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
