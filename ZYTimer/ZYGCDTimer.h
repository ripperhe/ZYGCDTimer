//
//  ZYGCDTimer.h
//  ZYTimerDemo
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



- (void)fire;

- (void)invalidate;

- (void)pause;


@end
