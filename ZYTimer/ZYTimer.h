//
//  ZYTimer.h
//  ZYTimerDemo
//
//  GitHub https://github.com/ripperhe
//  Created by ripper on 2017/2/15.
//  Copyright © 2017年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYTimer;

typedef void (^ZYCallbackBlock)(ZYTimer * _Nonnull timer, NSTimeInterval currentTime, NSInteger repeatCount);

@interface ZYTimer : NSObject

@property (readonly) NSInteger repeatCount;

@property (readonly) NSTimeInterval currentTime;

@property (readonly) NSTimeInterval interval;

@property (readonly, nullable) id userInfo;


/**
 创建一个定时器

 @param interval 周期
 @param aTarget 对象
 @param aSelector 方法
 @param userInfo 用户信息
 @param repeats 是否重复
 @param lifeDependObject 定时器随着该对象的销毁而销毁，默认为 target
 @return ZYTimer 对象
 */
+ (nonnull instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                       target:(nonnull id)aTarget
                                     selector:(nonnull SEL)aSelector
                                     userInfo:(nullable id)userInfo
                                      repeats:(BOOL)repeats
                             lifeDependObject:(nullable id)lifeDependObject;


/**
 创建一个定时器

 @param interval 周期
 @param userInfo 用户信息
 @param repeats 是否重复
 @param lifeDependObject 定时器随着该对象的销毁而销毁，不能传空值
 @param block 回调的block
 @return ZYTimer 对象
 */
+ (nonnull instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                                     userInfo:(nullable id)userInfo
                                      repeats:(BOOL)repeats
                             lifeDependObject:(nonnull id)lifeDependObject
                                        block:(nonnull ZYCallbackBlock)block;

/**
 开始 | 恢复
 */
- (void)fire;

/**
 暂停
 
 @note 重新 fire 时，除开 NSTimer 本身误差之外，还会有 <interval 的一个延迟，因为并不知道暂停的时候当前周期已经执行了多久。重新 fire 默认为上一次刚好回调完成，等待一个周期，进行第一次回调。
 */
- (void)pause;

/**
 销毁
 
 @note 调用该方法后不可重新 fire，如果不再需要重新开启，建议调用该方法
 */
- (void)invalidate;

@end
