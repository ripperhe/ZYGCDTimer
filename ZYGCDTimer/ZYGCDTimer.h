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

typedef void (^ZYGCDTimerCallbackBlock)(ZYGCDTimer * _Nonnull timer);

@interface ZYGCDTimer : NSObject

@property (readonly) NSTimeInterval interval;
@property (readonly) id _Nullable userInfo;

/** The error range of the timer, default is 0.1. Even if the tolerance is set to 0.0, the timer will also exist error. */
@property (atomic, assign) NSTimeInterval tolerance;


/**
 Create a timer

 @param interval how frequently `selector` will be invoked on `target`.
 @param aTarget target object
 @param aSelector selector
 @param userInfo additional information
 @param repeats if `YES`, `selector` will be invoked on `target` until the `ZYGCDTimer` object is deallocated or until you call `invalidate`. If `NO`, it will only be invoked once.
 @param dispatchQueue the queue where the delegate method will be dispatched. It can be either a serial or concurrent queue.
 @return timer
 */
+ (nonnull instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                       target:(nonnull id)aTarget
                                     selector:(nonnull SEL)aSelector
                                     userInfo:(nullable id)userInfo
                                      repeats:(BOOL)repeats
                                dispatchQueue:(nonnull dispatch_queue_t)dispatchQueue;

/**
 Create a timer

 @param interval how frequently `block` will be invoked.
 @param userInfo additional information
 @param repeats if `YES`, `block` will be invoked until the `ZYGCDTimer` object is deallocated or until you call `invalidate`. If `NO`, it will only be invoked once.
 @param dispatchQueue the queue where the delegate method will be dispatched. It can be either a serial or concurrent queue.
 @param block block
 @return timer
 */
+ (nonnull instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                     userInfo:(nullable id)userInfo
                                      repeats:(BOOL)repeats
                                dispatchQueue:(nonnull dispatch_queue_t)dispatchQueue
                                        block:(nonnull ZYGCDTimerCallbackBlock)block;

/**
 Start the timer
 */
- (void)fire;

/**
 Invalidate the timer
 
 @note After this method is used, it is not possible to restart the timer
 */
- (void)invalidate;

/**
 Pause the timer
 
 @note Use 'fire' to restart the timer
 */
- (void)pause;

@end
