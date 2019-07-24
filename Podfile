# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

project 'Debuggit.xcodeproj'

def shared_pods
  pod 'Alamofire', '~> 5.0.0-beta.6'
  pod 'SwiftyJSON', '~> 5.0.0'
  pod 'IQKeyboardManagerSwift', '~> 6.3.0'
  pod 'KMPlaceholderTextView', '~> 1.4.0'
  pod 'RNCryptor', '~> 5.0'
  pod 'ReachabilitySwift', '~> 4.3.1'
  pod 'AWSCore', '~> 2.10.0'
  pod 'AWSS3', '~> 2.10.0'
end

target 'DebuggIt' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DebuggIt
  shared_pods
end

target 'DebuggItDemo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DebuggIt
  shared_pods
end
  
target 'DebuggItTests' do
      use_frameworks!
      
      shared_pods
end
