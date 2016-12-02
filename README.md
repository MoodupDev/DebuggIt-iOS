# DebuggIt

[![Version](https://img.shields.io/cocoapods/v/DebuggIt.svg?style=flat)](http://cocoapods.org/pods/DebuggIt)
[![License](https://img.shields.io/cocoapods/l/DebuggIt.svg?style=flat)](http://cocoapods.org/pods/DebuggIt)
[![Platform](https://img.shields.io/cocoapods/p/DebuggIt.svg?style=flat)](http://cocoapods.org/pods/DebuggIt)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Development

To develop this project open `DebuggIt.xcworkspace` located in *Example* directory.

```shell
cd Example
open DebuggIt.xcworkspace
```

All source files are located in `Development Pods` group under `Pods` project.

## Installation

Currently DebuggIt is available only through this repository. To install
it, simply add the following line to your Podfile:

```ruby
pod "DebuggIt", :git => "https://bitbucket.org/moodup/debugg.it-ios.git"
```

Then in your `AppDelegate` file add this line to initialize debugg.it:

*Swift*:

- Bitbucket

```swift
DebuggIt.sharedInstance.initBitbucket(repoSlug: "your-repo-name", accountName: "your-username")
```

- Github

```swift
DebuggIt.sharedInstance.initGithub(repoSlug: "your-repo-name", accountName: "your-username")
```

*Objective-C*:

- Bitbucket

```
[[DebuggIt sharedInstance] initBitbucketWithRepoSlug: @"your-repo-name" accountName:@"your-username"];
```

- Github

```
[[DebuggIt sharedInstance] initGithubWithRepoSlug: @"your-repo-name" accountName:@"your-username"];
```

Add `DebuggItViewControllerProtocol` to all of your view controllers when you want to have debugg.it available.

- *Swift*:

```swift
import UIKit
import DebuggIt

class ViewController: UIViewController, DebuggItViewControllerProtocol {
	// ...
}
```

- *Objective-C*:

```
#import "ViewController.h"
@import DebuggIt;

@interface ViewController () <DebuggItViewControllerProtocol>

@implementation ViewController
```

## Author

Mood Up Labs, biuro@mooduplabs.com

## License

DebuggIt is available under the MIT license. See the LICENSE file for more info.
