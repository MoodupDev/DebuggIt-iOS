# DebuggIt

[![Version](https://img.shields.io/cocoapods/v/DebuggIt.svg?style=flat)](http://cocoapods.org/pods/DebuggIt)
[![License](https://img.shields.io/cocoapods/l/DebuggIt.svg?style=flat)](http://cocoapods.org/pods/DebuggIt)
[![Platform](https://img.shields.io/cocoapods/p/DebuggIt.svg?style=flat)](http://cocoapods.org/pods/DebuggIt)

## Prerequisites

- iOS 9.0+
- Xcode 8.0+
- Swift 3.0+ or Objective-C

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

Currently DebuggIt is available only through this repository. To install
it, simply add the following line to your Podfile:

```ruby
pod "DebuggIt", :git => "https://bitbucket.org/moodup/debugg.it-ios.git"
```

Then in your `AppDelegate` file add this line to initialize debugg.it:

*Swift*:

```swift
// Bitbucket
DebuggIt.sharedInstance.initBitbucket(repoSlug: "repo-name", accountName: "repo-owner-username")
// or Github
DebuggIt.sharedInstance.initGithub(repoSlug: "repo-name", accountName: "repo-owner-username")
// or JIRA
DebuggIt.sharedInstance.initJira(host: "jira-host-url", projectKey: "project-key")
```

*Objective-C*:

```objc
// Bitbucket
[[DebuggIt sharedInstance] initBitbucketWithRepoSlug: @"repo-name" accountName:@"repo-owner-username"];
// or Github
[[DebuggIt sharedInstance] initGithubWithRepoSlug: @"repo-name" accountName:@"repo-owner-username"];
// or JIRA
[[DebuggIt sharedInstance] initJiraWithHost:@"jira-host-url" projectKey:@"project-key" usesHttps:YES];
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

To develop this project, open `DebuggIt.xcworkspace` located in `Example` directory.

```shell
cd Example
open DebuggIt.xcworkspace
```

All source files are located in `Development Pods` group under `Pods` project.

## Author

Mood Up Labs, biuro@mooduplabs.com

## License

DebuggIt is available under the MIT license. See the LICENSE file for more info.
