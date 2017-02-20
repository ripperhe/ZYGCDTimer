//
//  ZYTimer.m
//  ZYTimerDemo
//
//  GitHub https://github.com/ripperhe
//  Created by ripper on 2017/2/15.
//  Copyright © 2017年 ripper. All rights reserved.
//

#import "ZYTimer.h"


@interface ZYTimer ()

@property (nonatomic, assign) BOOL isTarget;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, assign) BOOL hasSkipFirstTime;

@property (nonatomic, assign) NSInteger repeatCount;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, weak) id aTarget;
@property (nonatomic, assign) SEL aSelector;
@property (nonatomic, copy) ZYCallbackBlock callbackBlock;

@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) BOOL isRepeats;
@property (nonatomic, weak) id lifeDependObject;

@end

@implementation ZYTimer

- (void)dealloc
{
    NSLog(@"ZYTimer dealloc");
}

- (instancetype)initWithInterval:(NSTimeInterval)interval
                        userInfo:(id)userInfo
                         repeats:(BOOL)repeats
                lifeDependObject:(id)lifeDependObject {
    if (self = [super init]) {
        self.interval = interval;
        self.userInfo = userInfo;
        self.isRepeats = repeats;
        self.lifeDependObject = lifeDependObject;
        
        self.isPause = YES;
        self.isValid = YES;
        self.hasSkipFirstTime = NO;
    }
    return self;
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                               target:(nonnull id)aTarget
                             selector:(nonnull SEL)aSelector
                             userInfo:(id)userInfo
                              repeats:(BOOL)repeats
                     lifeDependObject:(id)lifeDependObject
{
    ZYTimer *timer = [[ZYTimer alloc] initWithInterval:interval
                                              userInfo:userInfo
                                               repeats:repeats
                                      lifeDependObject:lifeDependObject?lifeDependObject:aTarget];
    timer.aTarget = aTarget;
    timer.aSelector = aSelector;
    timer.isTarget = YES;
    return timer;
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                             userInfo:(id)userInfo
                              repeats:(BOOL)repeats
                     lifeDependObject:(id)lifeDependObject
                                block:(ZYCallbackBlock)block
{
    ZYTimer *timer = [[ZYTimer alloc] initWithInterval:interval
                                              userInfo:userInfo
                                               repeats:repeats
                                      lifeDependObject:lifeDependObject];
    timer.callbackBlock = block;
    timer.isTarget = NO;
    return timer;
}

- (void)fire
{
    if (self.isValid == YES) {
        if (self.isPause == YES) {
            self.isPause = NO;
        }else{
            return;
        }
        
        if (self.timer) {
            [self.timer fire];
        }else{
            // 处于暂停状态，没有被废弃，所以可以继续开始
            NSTimer *aTimer = [NSTimer timerWithTimeInterval:self.interval target:self selector:@selector(handleTimerCallBack) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSRunLoopCommonModes];
            self.timer = aTimer;
            [self.timer fire];
        }
        
    }else {
        NSLog(@"ZYTimer 已经被 invalidate，无法开始，想继续使用，需要重新创建 ZYTimer；前面如果只是想使用暂停功能，请用 pause 替换 invalidate 方法");
    }
}

- (void)pause
{
    self.isPause = YES;
    self.hasSkipFirstTime = NO;
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)invalidate
{
    self.isValid = NO;
    
    [self.timer invalidate];
    self.timer = nil;
    
    self.aTarget = nil;
    self.aSelector = NULL;
    self.callbackBlock = nil;
    
    self.interval = 0;
    self.userInfo = nil;
    self.isRepeats = NO;
    self.lifeDependObject = nil;
}

#pragma mark - 处理定时器回调
- (void)handleTimerCallBack
{
    if (self.hasSkipFirstTime == NO) {
        // 开启定时器会立即调用该方法，所以忽略第一次调用
        self.hasSkipFirstTime = YES;
        return;
    }
    
    // 处理定时器回调
    if (self.lifeDependObject) {
        self.repeatCount ++;
        self.currentTime += self.interval;
        
        if (_isTarget) {
            // target selector 类型
            if ([self.aTarget respondsToSelector:self.aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.aTarget performSelector:self.aSelector withObject:self];
#pragma clang diagnostic pop
            }else{
                NSLog(@"ZYTimer: target 没有对应的 selector，请检查");
                [self invalidate];
            }
        }else{
            // block 类型
            if (self.callbackBlock) {
                self.callbackBlock(self, self.currentTime, self.repeatCount);
            }else{
                NSLog(@"ZYTimer: callbackBlock 为空，请检查");
                [self invalidate];
            }
        }
        
        if (self.isRepeats == NO) {
            // 这里其实也可以调用 invalidate，可能 invalidate 会更好；用 pause 只是为了支持可以重新 fire
            self.currentTime = -1;
            [self pause];
        }
        
    }else{
        [self invalidate];
    }
}


@end
