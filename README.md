# ZYGCDTimer

[![Version](https://img.shields.io/cocoapods/v/ZYGCDTimer.svg?style=flat)](http://cocoapods.org/pods/ZYGCDTimer)
[![License](https://img.shields.io/cocoapods/l/ZYGCDTimer.svg?style=flat)](http://cocoapods.org/pods/ZYGCDTimer)
[![Platform](https://img.shields.io/cocoapods/p/ZYGCDTimer.svg?style=flat)](http://cocoapods.org/pods/ZYGCDTimer)

ZYGCDTimer is based on the [MSWeakTimer](https://github.com/mindsnacks/MSWeakTimer).

## Features

* **Create a timer with block**
			
* **Pause the timer**

## Example

To run the example project, clone the repo, and run directly.

![](https://raw.githubusercontent.com/ripperhe/Resource/master/20170314/gcdtimer.png)

## Requirements

iOS 8.0 or later

## Installation

ZYGCDTimer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ZYGCDTimer"
```

## How to use

You can use the following method to create a timer, and then use the "fire" method to start the timer.

* Target-selector

```objc****
+ (nonnull instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                       target:(nonnull id)aTarget
                ****                     selector:(nonnull SEL)aSelector
                                     userInfo:(nullable id)userInfo****
                                      repeats:(BOOL)repeats
                                dispatchQueue:(nonnull dispatch_queue_t)dispatchQueue;
```

* Block

```objc
+ (nonnull instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                     userInfo:(nullable id)userInfo
                                      repeats:(BOOL)repeats
                                dispatchQueue:(nonnull dispatch_queue_t)dispatchQueue
                                        block:(nonnull ZYGCDTimerCallbackBlock)block;
```

## Author

ripperhe, ripperhe@qq.com

## License

ZYGCDTimer is available under the MIT license. See the LICENSE file for more info.
