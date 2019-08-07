Pod::Spec.new do |s|
  s.name         = "DebuggIt"
  s.version      = "1.0.3"
  s.summary      = "Tool that will help QA and clients report bugs easily directly from the device"
  s.description  = <<-DESCRIPTION_CONTENT
# debugg.it
[https://debugg.it](https://debugg.it)

## Table of Contents ##

+ [What is this repository for?](#what-is-this)
+ [Example](#example)
+ [Installation](#setup)
+ [Configure and initialize debugg.it in your project](#configure)
    * [Configure service for issues](#configure-issue)
    * [API for uploading image files and (optionally) audio files](#configure-api)
    * [Sample configuration](#configure-sample)
+ [Additional options](#extra-options)
+ [Author](#author)
+ [Licence](#licence)

<a name="what-is-this"/>

## What is this repository for? ##

This is a library, which provides a tool to report iOS application bugs directly into JIRA / GitHub/ BitBucket Issue Tracker.

<a name="example"/>

# Example

To run the example project, open `DebuggIt.xcworkspace`, choose `DebuggItDemo` scheme and build it.

<a name="setup"/>

## Installation ##

debugg.it is available through CocoaPods. To install it, add the following to your Podfile and run `pod install`:
```ruby
use_modular_headers!
pod 'DebuggIt'
```
<a name="configure"/>

## Configure and initialize debugg.it in your project ##

In your `AppDelegate` import the pod:
```swift
import DebuggIt
```

<a name="configure-issue"/>

### Configure service for issues ###

Add one of these lines (**at start of method**) to initialize debugg.it issue service

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    ...
    // Override point for customization after application launch.
    DebuggIt.sharedInstance.initBitbucket(repoSlug: "repo-name", accountName: "repo-owner-username")
    // or Github
    DebuggIt.sharedInstance.initGithub(repoSlug: "repo-name", accountName: "repo-owner-username")
    // or JIRA
    DebuggIt.sharedInstance.initJira(host: "jira-host-url", projectKey: "project-key")
    ...
    return true
}
```

**Note**: If you are using **JIRA** and your host **do not use SSL**, use additional parameter in initialize method:

```swift
DebuggIt.sharedInstance.initJira(host: "jira-host-url", projectKey: "project-key", usesHttps: false)
```

<a name="configure-api"/>

### API for uploading image files and (optionally) audio files ###

debugg.it requires an API where it can send image files and (optionally) audio files. There are 3 available configurations:

+ AWS S3 Bucket

    This configuration uses your AWS S3 bucket (https://aws.amazon.com/s3/) to store image and audio files.

    * `DebuggIt.sharedInstance.initAWS(bucketName: "bucketName", regionType: .EUCentral1, identityPool: "identityPool")`
        * where
            * `bucketName` is a name of your bucket
            * `regionType` is a`AWSRegionType` where your S3 bucket is hosted
            * `identityPool` is a cognito generated key for your S3 bucket

##

+ Default API

    This configuration uses your backend to send image and audio files. Data is sent via POST call on given endpoint with following parameter:
    ```json
    {
        "data": "base64String"
    }
    ```
    
    * `DebuggIt.getInstance().initDefaultStorage(url: "baseUrl", imagePath: "imagePath", audioPath: "audioPath")`
        * where
            * `baseUrl` is a base url of your backend (e.g. `https://url-to-backend.com`)
            * `imagePath` is an endpoint handling image upload (e.g. `/debuggit/uploadImage`)
            * `audioPath` is an endpoint handling audio upload (e.g. `/debuggit/uploadAudio`)
##

+ Custom API

    This is an extension of default API configuration. The difference is that you have to handle `uploadImage` / `uploadAudio` request and response. You are responsible for communication with your backend, but at the same time you have full control over it.

    * `DebuggIt.sharedInstance.initCustomStorage(uploadImage: { (base64, delegate) in }, uploadAudio: { (base64, delegate) in })`
        * where
            * `uploadImage` is a callback with prepared base64 converted image and response delegate
                * `delegate` is a `ApiClientDelegate` object, and should call `.uploadSuccessClousure("url-to-image")` in case of success or `.errorClousure(code, message)`in case of error.
            * `uploadImage` is a callback with prepared base64 converted image and response delegate
                * `delegate` is a `ApiClientDelegate` object, and should call `.uploadSuccessClousure("url-to-audio")` in case of success or `.errorClousure(code, message)`in case of error.

<a name="configure-sample"/>

### Sample configurations ###

+ Init BitBucket with S3:
##
```swift
DebuggIt.sharedInstance
        .initAWS(bucketName: "bucketName", regionType: .EUCentral1, identityPool: "identityPool")
        .initBitbucket(repoSlug: "repo-name", accountName: "repo-owner-username")
```

+ Init GitHub with default API:
##
```swift
DebuggIt.sharedInstance
        .initDefaultStorage(url: "baseUrl", imagePath: "imagePath", audioPath: "audioPath")
        .initGithub(repoSlug: "repo-name", accountName: "repo-owner-username")
```

+ Init JIRA with custom API:
##
```swift
DebuggIt.sharedInstance
        .initCustomStorage(uploadImage: { (base64, delegate) in
            // Handle API call to your backend and call uploadSuccessClousure on delegate with url
            // delegate.uploadSuccessClousure("url-to-image")

            // If something went wrong, call errorClousure on delegate
            // delegate.errorClousure(400, "Could not upload image")
        }, uploadAudio: { (base64, delegate) in
            // Handle API call to your backend and call uploadSuccessClousure on delegate with url
            // delegate.uploadSuccessClousure("url-to-audio")

            // If something went wrong, call errorClousure on delegate
            // delegate.errorClousure(400, "Could not upload audio")    
        })
        .initJira(host: "jira-host-url", projectKey: "project-key")
```
## That's all. Your debugg.it is ready to work. ##

<a name="extra-options"/>

## Additional options

**debugg.it** allows to record audio notes and add it to bug description. To enable this feature simply add this line to your configuration in `AppDelegate` class:


```swift
DebuggIt.sharedInstance.recordingEnabled = true
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
  s.license         = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author          = { "MoodUp.team" => "biuro@mooduplabs.com" }
  s.source          = { http: "https://github.com/MoodupDev/DebuggIt-iOS/releases/download/#{s.version}/DebuggIt.framework" }
  s.preserve_paths = '*'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
end
