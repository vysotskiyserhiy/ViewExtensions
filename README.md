# ViewExtensions

[![Version](https://img.shields.io/cocoapods/v/ViewExtensions.svg?style=flat)](http://cocoapods.org/pods/ViewExtensions)
[![License](https://img.shields.io/cocoapods/l/ViewExtensions.svg?style=flat)](http://cocoapods.org/pods/ViewExtensions)
[![Platform](https://img.shields.io/cocoapods/p/ViewExtensions.svg?style=flat)](http://cocoapods.org/pods/ViewExtensions)

## Example

```swift
// handle any gesture is only one line of code
view.recognize(.tap) {
    // handle tap
}

// if you need any additional setup
view.recognize(.longPress, setup: { (gesture) in
    let longPress = gesture as! UILongPressGestureRecognizer
    // setup
}, handler: {
    // handle longPress
})

let button = UIButton(type: .infoDark)

// you can set padding to increase button response frame
button.padding = 20

button.handle(.touchUpInside) {
    // handle tap
}

// extend view's tap zone is that easy
view.padding = 10

let imageView = UIImageView()

imageView.recognize(.tap) {
    // handle tap
}
```

## Installation

ViewExtensions is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ViewExtensions'
```

## Author

vysotskiyserhiy, vysotskiyserhiy@gmail.com

## License

ViewExtensions is available under the MIT license. See the LICENSE file for more info.
