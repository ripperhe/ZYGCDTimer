//
//  ZYGCDTimer.m
//  ZYGCDTimerDemo
//
//  GitHub https://github.com/ripperhe
//  Created by ripper on 2017/2/20.
//  Copyright © 2017年 ripper. All rights reserved.
//

#import "ZYGCDTimer.h"
#import <libkern/OSAtomic.h>

@interface ZYGCDTimer () {
    struct
    {
        uint32_t timerIsInvalidated;
        uint32_t timerIsPaused;
        uint32_t timerIsFired;
    } _timerFlags;
}

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) void(^block)(ZYGCDTimer *timer);

@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) BOOL isRepeats;

@property (nonatomic, strong) dispatch_queue_t privateSerialQueue;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) BOOL isTarget;

@end


@implementation ZYGCDTimer

@synthesize tolerance = _tolerance;

- (void)dealloc {
    NSLog(@"%@ dealloc", self.description);
    [self invalidate];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)interval
                            userInfo:(id)userInfo
                             repeats:(BOOL)repeats
                       dispatchQueue:(dispatch_queue_t)dispatchQueue {
    if (self = [super init]) {
        self.interval = interval;
        self.userInfo = userInfo;
        self.isRepeats = repeats;
        _tolerance = 0.1;
        
        NSString *privateQueueName = [NSString stringWithFormat:@"com.ripperhe.zygcdtimer.%p", self];
        self.privateSerialQueue = dispatch_queue_create([privateQueueName cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        // 将 privateSerialQueue 与 dispatchQueue 串行执行
        dispatch_set_target_queue(self.privateSerialQueue, dispatchQueue);
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                            0,
                                            0,
                                            self.privateSerialQueue);
        
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(self.timer, ^{
            __strong typeof(weakSelf) self = weakSelf;
            [self timerCallback];
        });
        dispatch_resume(self.timer);
    }
    return self;
}

- (void)resetTime {
    int64_t intervalInNanoseconds = (int64_t)(self.interval * NSEC_PER_SEC);
    int64_t toleranceInNanoseconds = (int64_t)(self.tolerance * NSEC_PER_SEC);
    
    dispatch_source_set_timer(self.timer,
                              dispatch_time(DISPATCH_TIME_NOW, intervalInNanoseconds),
                              (uint64_t)intervalInNanoseconds,
                              toleranceInNanoseconds
                              );
}

#pragma mark - API
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                               target:(nonnull id)aTarget
                             selector:(nonnull SEL)aSelector
                             userInfo:(id)userInfo
                              repeats:(BOOL)repeats
                        dispatchQueue:(dispatch_queue_t)dispatchQueue {
    NSParameterAssert(aTarget);
    NSParameterAssert(aSelector);
    NSParameterAssert(dispatchQueue);
    
    ZYGCDTimer *timer = [[ZYGCDTimer alloc] initWithTimeInterval:interval userInfo:userInfo repeats:repeats dispatchQueue:dispatchQueue];
    timer.target = aTarget;
    timer.selector = aSelector;
    timer.isTarget = YES;
    return timer;
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                             userInfo:(id)userInfo
                              repeats:(BOOL)repeats
                        dispatchQueue:(dispatch_queue_t)dispatchQueue
                                block:(nonnull void (^)(ZYGCDTimer * _Nonnull))block {
    NSParameterAssert(block);
    NSParameterAssert(dispatchQueue);
    
    ZYGCDTimer *timer = [[ZYGCDTimer alloc] initWithTimeInterval:interval userInfo:userInfo repeats:repeats dispatchQueue:dispatchQueue];
    timer.block = block;
    timer.isTarget = NO;
    return timer;
}

- (void)fire {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (OSAtomicAnd32OrigBarrier(1, &_timerFlags.timerIsInvalidated)) return;
    
    if (OSAtomicTestAndSetBarrier(7, &_timerFlags.timerIsFired)) return;
    
    if (OSAtomicTestAndClear(7, &_timerFlags.timerIsPaused)) {
#pragma clang diagnostic pop
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                            0,
                                            0,
                                            self.privateSerialQueue);
        
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(self.timer, ^{
            __strong typeof(weakSelf) self = weakSelf;
            [self timerCallback];
        });
        dispatch_source_t timer = self.timer;
        dispatch_async(self.privateSerialQueue, ^{
            dispatch_resume(timer);
        });
    }
    [self resetTime];
}

- (void)invalidate {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!OSAtomicTestAndSetBarrier(7, &_timerFlags.timerIsInvalidated)) {
        OSAtomicTestAndClear(7, &_timerFlags.timerIsFired);
#pragma clang diagnostic pop
        dispatch_source_t timer = self.timer;
        dispatch_async(self.privateSerialQueue, ^{
            dispatch_source_cancel(timer);
        });
    }
}

- (void)pause {
    /*
     dispatch_resume() 与 dispatch_suspend() 是平衡挂起计数的
     
     当一个 dispatch 的 timer 对象为挂起状态，被销毁会导致程序崩溃，所以这里采用重新创建 timer 的方式实现 pause 功能
     */
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (OSAtomicAnd32OrigBarrier(1, &_timerFlags.timerIsInvalidated) || !OSAtomicAnd32OrigBarrier(1, &_timerFlags.timerIsFired)) return;
    
    if (!OSAtomicTestAndSetBarrier(7, &_timerFlags.timerIsPaused)) {
        OSAtomicTestAndClear(7, &_timerFlags.timerIsFired);
        dispatch_source_t timer = self.timer;
        dispatch_async(self.privateSerialQueue, ^{
            dispatch_source_cancel(timer);
        });
    }
#pragma clang diagnostic pop
}

- (void)setTolerance:(NSTimeInterval)tolerance {
    @synchronized(self) {
        if (tolerance != _tolerance) {
            _tolerance = tolerance;
            [self resetTime];
        }
    }
}

- (NSTimeInterval)tolerance {
    @synchronized(self) {
        return _tolerance;
    }
}

#pragma mark - timer callback

- (void)timerCallback {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (OSAtomicAnd32OrigBarrier(1, &_timerFlags.timerIsInvalidated) ||
        OSAtomicAnd32OrigBarrier(1, &_timerFlags.timerIsPaused)) {
        return;
    }
#pragma clang diagnostic pop
    
    if (self.isTarget) {
        if (self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id target = self.target;
            [target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
        }else {
            [self invalidate];
        }
    }else {
        if (self.block) {
            self.block(self);
        }else {
            [self invalidate];
        }
    }
    
    if (!self.isRepeats) {
        [self invalidate];
    }
}

@end
