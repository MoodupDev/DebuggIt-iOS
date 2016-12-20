#
# Be sure to run `pod lib lint DebuggIt.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = "DebuggIt"
  s.version      = "0.1.1"
  s.summary      = "Tool that will help QA and clients report bugs easily directly from the device"


# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description  = <<-DESC
DebuggIt is a simple, yet powerful tool that helps you get reports of the bugs directly to your defined issue tracker. It is a perfect tool for QA/clients.
                   DESC

  s.homepage        = "http://debugg.it"
  # s.screenshots   = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license         = { :type => 'MIT', :file => 'LICENSE' }
  s.author          = { "Mood Up" => "biuro@mooduplabs.com" }
  s.source          = { :git => "https://bitbucket.org/moodup/debugg.it-ios.git", :tag => "#{s.version}" }

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'DebuggIt/Classes/**/*.swift'
  # s.resources = "DebuggIt/**/*.{png,jpeg,jpg,storyboard,xib}"

  
  s.resource_bundles = {
    'DebuggIt' => ['DebuggIt/Assets/**/*.{xcassets,xib}', 'DebuggIt/Localization/*.lproj']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency "Alamofire", "~> 4.0"
  s.dependency "SwiftyJSON"
  s.dependency "IQKeyboardManagerSwift", "~> 4.0.6"
  s.dependency 'KMPlaceholderTextView', '~> 1.3.0'
  s.dependency 'RNCryptor'

end
