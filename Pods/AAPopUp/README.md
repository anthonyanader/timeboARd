
# Table of Contents

- [AAPopUp](#section-id-4)
  - [Description](#section-id-11)
  - [Demonstration](#section-id-16)
  - [Requirements](#section-id-26)
- [Installation](#section-id-31)
  - [CocoaPods](#section-id-36)
  - [Carthage](#section-id-61)
  - [Manual Installation](#section-id-79)
- [Getting Started](#section-id-87)
  - [Define Global Options:](#section-id-88)
  - [Define Popups through Identifiers](#section-id-100)
  - [Construct your first Popup!](#section-id-120)
  - [Access your objects](#section-id-129)
  - [Present your popup](#section-id-141)
  - [Helper functions](#section-id-152)
- [Contributions & License](#section-id-169)


<div id='section-id-4'/>

#AAPopUp

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![CocoaPods](https://img.shields.io/cocoapods/v/AAPopUp.svg)](http://cocoadocs.org/docsets/AAPopUp) [![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://github.com/Carthage/Carthage) [![Build Status](https://travis-ci.org/EngrAhsanAli/AAPopUp.svg?branch=master)](https://travis-ci.org/EngrAhsanAli/AAPopUp) 
![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg) [![CocoaPods](https://img.shields.io/cocoapods/p/AAPopUp.svg)]()



<div id='section-id-11'/>

##Description


AAPopUp is a simple and easy-to-use popup view controller designed to present customizable storyboard based view controller as a modal alert, written in Swift. It supports tag-based and dedicated view controller based implementation.

<div id='section-id-16'/>

##Demonstration



![](https://github.com/EngrAhsanAli/AAPopUp/blob/master/Screenshots/demo.gif)


To run the example project, clone the repo, and run `pod install` from the Example directory first.


<div id='section-id-26'/>

##Requirements

- iOS 8.0+
- Xcode 8.0+
- Swift 3+

<div id='section-id-31'/>

# Installation

`AAPopUp` can be installed using CocoaPods, Carthage, or manually.


<div id='section-id-36'/>

##CocoaPods

`AAPopUp` is available through [CocoaPods](http://cocoapods.org). To install CocoaPods, run:

`$ gem install cocoapods`

Then create a Podfile with the following contents:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
pod 'AAPopUp'
end

```

Finally, run the following command to install it:
```
$ pod install
```


<div id='section-id-61'/>

##Carthage

To install Carthage, run (using Homebrew):
```
$ brew update
$ brew install carthage
```
Then add the following line to your Cartfile:

```
github "EngrAhsanAli/AAPopUp" 
```

Then import the library in all files where you use it:
```ruby
import AAPopUp
```

<div id='section-id-79'/>

##Manual Installation

If you prefer not to use either of the above mentioned dependency managers, you can integrate `AAPopUp` into your project manually by adding the files contained in the Classes folder to your project.

<div id='section-id-87'/>

#Getting Started
----------

> You need to put all contents of popup (UILabels, UIButtons etc) in a single view in the storyboard

<div id='section-id-88'/>

##Define Global Options:

```ruby
let options = AAPopUp.globalOptions
options.storyboardName = "Main"
options.dismissTag = 9
options.cornerRadius = 4.0
options.animationDuration = 0.3
options.backgroundColor = UIColor.black.withAlphaComponent(0.7)
```


<div id='section-id-100'/>

##Define Popups through Identifiers

You can define your popups view controllers with their respective identifiers as follow:


```ruby

extension AAPopUp {

static let demo1 = AAPopUps<String? ,String>(identifier: "DemoPopup")
static let demo2 = AAPopUps<String? ,String>("Main" ,identifier: "DemoPopup")

}


```

Note that you storyboard name is optional, you can define in `GlobalOptions`.


<div id='section-id-120'/>

##Construct your first Popup!

You can just call the `AAPopUp` constructor by passing your view controller based popup as follow:

```ruby
var popup: AAPopUp = AAPopUp(popup: .demo2)
```


<div id='section-id-129'/>

##Access your objects

You can access your `UILabel`, `UIButton` etc simply by using `viewWithTag` function as follow:

```ruby
let label = popup.viewWithTag(10) as! UILabel
label.text = “Label Text“
```

> Note that you can define your attributes or set your objects as `viewDidLoad` before calling the presenting popup.


<div id='section-id-141'/>

##Present your popup

```
popup.present { popup in
// MARK:- View Did Appear Here
popup.dismissWithTag(9)   
}
```

> Note that you can define your attributes or set your objects as `viewDidAppear` after calling the presenting popup.

<div id='section-id-152'/>

##Helper functions

You can dismiss your constructed popup by just calling the following method:
```ruby
func dismissPopUpView(completion: (() -> ())? = nil)
```


You can get any view by its tag defined in storyboard by just calling the following method:

```ruby
func viewWithTag(_ tag: Int) -> UIView?
```

You can set default action to a UIButton to dissmiss by calling the following method:

```ruby
func dismissWithTag(_ tag: Int?)
```



<div id='section-id-169'/>

#Contributions & License

`AAPopUp` is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.

Pull requests are welcome! The best contributions will consist of substitutions or configurations for classes/methods known to block the main thread during a typical app lifecycle.

I would love to know if you are using `AAPopUp` in your app, send an email to [Engr. Ahsan Ali](mailto:hafiz.m.ahsan.ali@gmail.com)

