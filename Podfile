# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

def shared_pods
  pod 'Alamofire', "~> 4.0"
  pod 'SwiftyJSON'
  pod 'IQKeyboardManagerSwift'
  pod 'KMPlaceholderTextView', '~> 1.3.0'
  pod 'RNCryptor'
  pod 'ReachabilitySwift'
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
