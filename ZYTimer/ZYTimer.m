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
@property (getter=isValid) BOOL valid;
@property (nonatomic, assign) NSTimeInterval currentTime;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, weak) id aTarget;
@property (nonatomic, assign) SEL aSelector;
@property (nonatomic, copy) ZYCallbackBlock callbackBlock;

@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) BOOL isRepeats;
@property (nonatomic, weak) id lifeDependObject;

@end

@implementation ZYTimer

- (void)dealloc
{
    NSLog(@"ZYTimer dealloc");
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval target:(nonnull id)aTarget selector:(nonnull SEL)aSelector repeats:(BOOL)repeats lifeDependObject:(id)lifeDependObject
{
    ZYTimer *timer = [[ZYTimer alloc] init];
    timer.aTarget = aTarget;
    timer.aSelector = aSelector;
    timer.interval = interval;
    timer.isRepeats = repeats;
    timer.lifeDependObject = lifeDependObject?lifeDependObject:aTarget;
    
    timer.isTarget = YES;
    timer.isPause = YES;
    timer.valid = YES;
    timer.currentTime = -1;

    return timer;
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats lifeDependObject:(id)lifeDependObject block:(ZYCallbackBlock)block
{
    ZYTimer *timer = [[ZYTimer alloc] init];
    timer.callbackBlock = block;
    timer.interval = interval;
    timer.isRepeats = repeats;
    timer.lifeDependObject = lifeDependObject;
    
    timer.isTarget = NO;
    timer.isPause = YES;
    timer.valid = YES;
    timer.currentTime = -1;
    
    return timer;
}

- (void)fire
{
    if (self.valid == YES) {
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
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)invalidate
{
    self.valid = NO;
    
    [self.timer invalidate];
    self.timer = nil;
    
    self.aTarget = nil;
    self.aSelector = NULL;
    self.callbackBlock = nil;
    
    self.interval = 0;
    self.isRepeats = NO;
    self.lifeDependObject = nil;
}

#pragma mark - 处理定时器回调
- (void)handleTimerCallBack
{
    if (self.isPause) {
        NSLog(@"这里应该不会调用吧");
        [self pause];
        return;
    }
    
    if (self.isValid == NO) {
        NSLog(@"这里应该不会调用吧");
        [self invalidate];
        return;
    }
    
    if (self.currentTime < 0) {
        // 开启定时器会立即调用该方法，所以忽略第一次调用
        self.currentTime = 0;
        return;
    }
    
    // 处理定时器回调
    if (self.lifeDependObject) {
        self.currentTime += self.interval;
        
        if (_isTarget) {
            // target selector 类型
            if ([self.aTarget respondsToSelector:self.aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.aTarget performSelector:self.aSelector];
#pragma clang diagnostic pop
            }else{
                [self invalidate];
            }
        }else{
            // block 类型
            if (self.callbackBlock) {
                self.callbackBlock(self, self.currentTime);
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
