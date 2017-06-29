# DebuggIt

[![Version](https://img.shields.io/cocoapods/v/DebuggIt.svg?style=flat)](http://cocoapods.org/pods/DebuggIt)
[![License](https://img.shields.io/cocoapods/l/DebuggIt.svg?style=flat)](http://cocoapods.org/pods/DebuggIt)
[![Platform](https://img.shields.io/cocoapods/p/DebuggIt.svg?style=flat)](http://cocoapods.org/pods/DebuggIt)

## Prerequisites

- iOS 9.0+
- Xcode 8.0+
- Swift 3.0+ or Objective-C

## Example

To run the example project, open `DebuggIt.xcworkspace`, choose `DebuggItDemo` scheme and build it.

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

## Development

To develop this project, open `DebuggIt.xcworkspace`.

```shell
open DebuggIt.xcworkspace
```

All source files are located in `DebuggIt` group under `DebuggIt` project.

## Deployment

To deploy new version of `DebuggIt`, you must:

1. Choose `DebuggIt-Production` build scheme
2. Archive `.framework` file
	1. Make sure that there's custom post-archive script in `DebuggIt-Production` scheme. 
	To do this, choose `DebuggIt-Production` scheme and click **Product -> Scheme -> Edit Scheme** (or `Cmd + Shift + <`). 
	Expand **Archive** in the side menu. If there's no custom **Post-action** script, add new script. 
	Paste contents of `archive_post_action_script.sh` into the Run Script window.
	Be sure to select `DebuggIt` for the **Provide build settings from** setting and click Close to apply the changes.
	2. Ensure that **Skip Install** setting in framework target's **Build Settings** is set to `No`
	3. Archive the framework by clicking **Product -> Archive** in the menu bar. If the option is greyed out, make sure to select a physical iOS device and not the iOS simulator.
	4. Once the bundle is archived, the Xcode Organizer will pop up. Wait a few more seconds, and the Finder should also open up directory with `DebuggIt.framework` inside it.
3. Use `deploy` script (**Note**: Ruby required)
	1. Open terminal in project directory
	2. Make sure that `deploy` script has execute permissions (`chmod +x deploy`)
	3. Use this script to deploy new version to server: `./deploy <version>` (e.g. `./deploy 1.0.1`)
4. Update pod
	1. Update version in `DebuggIt.podspec`
	2. Lint build using `pod lib lint DebuggIt.podspec`
	3. Update pod: `pod trunk push DebuggIt.podspec`

## Author

Mood Up Labs, biuro@mooduplabs.com

## License

DebuggIt is available under the MIT license. See the LICENSE file for more info.