//
//  ZYGCDTimer.h
//  ZYGCDTimerDemo
//
//  GitHub https://github.com/ripperhe
//  Created by ripper on 2017/2/20.
//  Copyright © 2017年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYGCDTimer;

typedef void (^ZYGCDTimerCallbackBlock)(ZYGCDTimer * _Nonnull timer, NSTimeInterval currentTime, NSInteger repeatCount);

@interface ZYGCDTimer : NSObject

@property (readonly) id _Nullable userInfo;
@property (readonly) NSTimeInterval currentTime;
@property (readonly) NSInteger repeatCount;

@property (atomic, assign) NSTimeInterval tolerance;

+ (nonnull instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                       target:(nonnull id)aTarget
                                     selector:(nonnull SEL)aSelector
                                     userInfo:(nullable id)userInfo
                                      repeats:(BOOL)repeats
                                dispatchQueue:(nonnull dispatch_queue_t)dispatchQueue;

+ (nonnull instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                     userInfo:(nullable id)userInfo
                                      repeats:(BOOL)repeats
                                dispatchQueue:(nonnull dispatch_queue_t)dispatchQueue
                                        block:(nonnull ZYGCDTimerCallbackBlock)block;


/**
 启动定时器
 */
- (void)fire;


/**
 销毁定时器
 
 @note 调用该方法之后，不可重新开启定时器
 */
- (void)invalidate;


/**
 暂停定时器
 
 @note 暂停之后可重新开启
 */
- (void)pause;

@end
