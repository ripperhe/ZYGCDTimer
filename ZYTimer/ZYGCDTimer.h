//
//  ZYGCDTimer.h
//  ZYTimerDemo
//
//  GitHub https://github.com/ripperhe
//  Created by ripper on 2017/2/20.
//  Copyright © 2017年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYGCDTimer : NSObject


@property (atomic, assign) NSTimeInterval tolerance;


+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval target:(nonnull id)aTarget selector:(nonnull SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats dispatchQueue:(dispatch_queue_t)dispatchQueue;

- (void)fire;

- (void)invalidate;

- (void)pause;


@end
