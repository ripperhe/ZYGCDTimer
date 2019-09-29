# ZYGCDTimer

[![Version](https://img.shields.io/cocoapods/v/ZYGCDTimer.svg?style=flat)](http://cocoapods.org/pods/ZYGCDTimer)
[![License](https://img.shields.io/cocoapods/l/ZYGCDTimer.svg?style=flat)](http://cocoapods.org/pods/ZYGCDTimer)
[![Platform](https://img.shields.io/cocoapods/p/ZYGCDTimer.svg?style=flat)](http://cocoapods.org/pods/ZYGCDTimer)

ZYGCDTimer 主要用于替代 `NSTimer`，不会强持有 target，基于 [MSWeakTimer](https://github.com/mindsnacks/MSWeakTimer) 进行修改的，本质上是个 `GCD` 定时器。

## Features

- [x] 弱引用 `target`
- [x] `target` 销毁之后，自动调用 `invalidate`
- [x] 支持 `block` 创建定时器
- [x] 支持设置 `GCD queue`
- [x] 支持暂停定时器

## Example

![](zygcdtimer.png)

下载 demo 直接运行即可

## Requirements

* iOS 8.0+
* macOS 10.12+

## Installation

ZYGCDTimer 支持 [CocoaPods](http://cocoapods.org) 安装。在 `Podfile` 中写入以下文本，然后执行 `pod install` 即可：

```ruby
pod "ZYGCDTimer"
```

## Usage

使用 `target-selector` 创建定时器

```objc
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                       target:(id)aTarget
                                     selector:(SEL)aSelector
                                     userInfo:(nullable id)userInfo
                                      repeats:(BOOL)repeats
                                dispatchQueue:(dispatch_queue_t)dispatchQueue;
```

使用 `block` 创建定时器

```objc
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                     userInfo:(nullable id)userInfo
                                      repeats:(BOOL)repeats
                                dispatchQueue:(dispatch_queue_t)dispatchQueue
                                        block:(void (^)(ZYGCDTimer *timer))block;
```

启用定时器

```objc
- (void)fire;
```

无效定时器

```objc
- (void)invalidate;
```

暂停定时器

```objc
- (void)pause;
```

## Author

ripperhe, ripperhe@qq.com

## License

ZYGCDTimer is available under the MIT license. See the LICENSE file for more info.
