# ViewExtensions

[![Version](https://img.shields.io/cocoapods/v/ViewExtensions.svg?style=flat)](http://cocoapods.org/pods/ViewExtensions)
[![License](https://img.shields.io/cocoapods/l/ViewExtensions.svg?style=flat)](http://cocoapods.org/pods/ViewExtensions)
[![Platform](https://img.shields.io/cocoapods/p/ViewExtensions.svg?style=flat)](http://cocoapods.org/pods/ViewExtensions)

# Example

## Add recognizers

```swift
let view = UIView()

view.recognize(.tap) {
    // handle tap
}

// if you need any additional setup

view.recognize(.longPress, setup: { (gesture) in
    // setup
}, handler: {
    // handle longPress
})

```

## Extend touches zone

```swift
view.padding = 10
```

## Same logic for UIButton

```swift
let button = UIButton(type: .infoDark)

// you can set padding to increase button response frame
button.padding = 20

button.handle(.touchUpInside) {
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
