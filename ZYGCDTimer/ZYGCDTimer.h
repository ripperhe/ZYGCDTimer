//
//  ZYGCDTimer.h
//  ZYGCDTimerDemo
//
//  GitHub https://github.com/ripperhe
//  Created by ripper on 2017/2/20.
//  Copyright © 2017年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYGCDTimer : NSObject

/// 调用时间间隔
@property (readonly) NSTimeInterval interval;

/// 用户信息
@property (readonly) id _Nullable userInfo;

/// 容忍度，单位秒，默认为 0.1；即便设置为 0.0 仍然存在误差
@property (atomic, assign) NSTimeInterval tolerance;

/// 创建一个定时器
/// @param interval 调用的时间间隔
/// @param aTarget 对象
/// @param aSelector 方法选择器
/// @param userInfo 用户信息
/// @param repeats 是否重复
/// @param dispatchQueue 派发事件的队列，可以是串行队列或并发队列
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                       target:(id)aTarget
                                     selector:(SEL)aSelector
                                     userInfo:(nullable id)userInfo
                                      repeats:(BOOL)repeats
                                dispatchQueue:(dispatch_queue_t)dispatchQueue;

/// 创建一个定时器
/// @param interval 调用的时间间隔
/// @param userInfo 用户信息
/// @param repeats 是否重复
/// @param dispatchQueue 派发事件的队列，可以是串行队列或并发队列
/// @param block 定时器事件
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                     userInfo:(nullable id)userInfo
                                      repeats:(BOOL)repeats
                                dispatchQueue:(dispatch_queue_t)dispatchQueue
                                        block:(void (^)(ZYGCDTimer *timer))block;

/// 启用定时器
- (void)fire;

/// 无效定时器
/// @note 调用该方法之后，将无法重启定时器
/// @note 如果是用 target selector 方式启用的定时器，target 销毁之后的第一次调用 selector 的时机会自动调用本方法
- (void)invalidate;

/// 暂停定时器
/// @note 调用本方法之后，可以用 fire 重启定时器
- (void)pause;

@end

NS_ASSUME_NONNULL_END
