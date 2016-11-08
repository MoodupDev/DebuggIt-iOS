# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'DebugIt' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DebugIt
    pod 'Alamofire', '~> 4.0'
    pod 'SwiftyJSON'
    pod 'IQKeyboardManagerSwift', '4.0.6'
    pod 'Nuke', '~> 4.0'
    
  target 'DebugItTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DebugItUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
