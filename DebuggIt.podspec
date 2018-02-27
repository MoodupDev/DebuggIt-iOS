#
# Be sure to run `pod lib lint DebuggIt.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = "DebuggIt"
  s.version      = "0.2.4"
  s.summary      = "Tool that will help QA and clients report bugs easily directly from the device"


# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description  = <<-DESCRIPTION_CONTENT
# debugg.it

debugg.it is a simple, yet powerful tool that helps you get reports of the bugs directly to your defined issue tracker. It is a perfect tool for QA/clients.

## Installation

debugg.it is available through CocoaPods. To install it, add the following to your Podfile:

```ruby
use_frameworks!
platform :ios, '9.0'
pod 'DebuggIt'
```

Don’t forget to import the Pod in `AppDelegate`:

```swift
import DebuggIt
```
or in Objective-C
```objc
@import DebuggIt;
```

and add one of these lines (**at start of method**) to initialize debugg.it

*Swift*:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    DebuggIt.sharedInstance.initBitbucket(repoSlug: "repo-name", accountName: "repo-owner-username")
    // or Github
    DebuggIt.sharedInstance.initGithub(repoSlug: "repo-name", accountName: "repo-owner-username")
    // or JIRA
    DebuggIt.sharedInstance.initJira(host: "jira-host-url", projectKey: "project-key")
    return true
}
```

*Objective-C*:

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Bitbucket
    [[DebuggIt sharedInstance] initBitbucketWithRepoSlug: @"repo-name" accountName:@"repo-owner-username"];
    // or Github
    [[DebuggIt sharedInstance] initGithubWithRepoSlug: @"repo-name" accountName:@"repo-owner-username"];
    // or JIRA
    [[DebuggIt sharedInstance] initJiraWithHost:@"jira-host-url" projectKey:@"project-key" usesHttps:YES];
    return YES;
}
```

**Note**: If you are using **JIRA** and your host **do not use SSL**, use additional parameter in initialize method:

```swift
DebuggIt.sharedInstance.initJira(host: "jira-host-url", projectKey: "project-key", usesHttps: false)
```

```objc
[[DebuggIt sharedInstance] initJiraWithHost:@"jira-host-url" projectKey:@"project-key" usesHttps:NO];
``` 

### Additional options

#### Record notes

**debugg.it** allows to record audio notes and add it to bug description. To enable this feature simply add this line in your `AppDelegate` file:

```swift
DebuggIt.sharedInstance.recordingEnabled = true
```

```objc
[DebuggIt sharedInstance].recordingEnabled = YES;
```

Ensure you have added _Microphone Usage Description_ in your `Info.plist` file. For example:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSMicrophoneUsageDescription</key>
	<string>debugg.it record notes</string>
	<!-- 
		Rest of Info.plist file... 
	-->
</dict>
</plist>
```
DESCRIPTION_CONTENT

  s.homepage        = "http://debugg.it"
  # s.screenshots   = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license         = { :type => 'MIT', :file => 'LICENSE' }
  s.author          = { "MoodUp.team" => "info@debugg.it" }
  s.source          = { :http => "http://debugg.it/downloads/ios/#{s.version}/DebuggIt.framework.zip" }

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.ios.vendored_frameworks = 'outputs/frameworks/DebuggIt.framework'

  s.dependency 'Alamofire', "~> 4.0"
  s.dependency 'SwiftyJSON', "~> 3.0"
  s.dependency 'IQKeyboardManagerSwift', '~> 5.0'
  s.dependency 'KMPlaceholderTextView', '~> 1.0'
  s.dependency 'RNCryptor', "~> 5.0"
  s.dependency 'ReachabilitySwift', "~> 3.0"

end
