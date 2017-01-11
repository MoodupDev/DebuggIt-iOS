#
# Be sure to run `pod lib lint DebuggIt.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = "DebuggIt"
  s.version      = "0.1.2"
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
  s.source          = { :http => "http://debugg.it/downloads/ios/#{s.version}/DebuggIt.framework.zip" }

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.ios.vendored_frameworks = 'DebuggIt.framework'

  s.dependency 'Alamofire', "~> 4.0"
  s.dependency 'SwiftyJSON'
  s.dependency 'IQKeyboardManagerSwift', '~> 4.0.6'
  s.dependency 'KMPlaceholderTextView', '~> 1.3.0'
  s.dependency 'RNCryptor'
  s.dependency 'ReachabilitySwift'

end
