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

@property (nonatomic, assign, readonly) NSInteger repeatCount;

@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

@property (nonatomic, assign, readonly) NSTimeInterval interval;

@property (nonatomic, strong, readonly, nullable) id userInfo;



/**
 创建一个定时器

 @param interval 周期
 @param aTarget 对象
 @param aSelector 方法
 @param repeats 是否重复
 @param userInfo 用户信息
 @param lifeDependObject 定时器随着该对象的销毁而销毁，默认为 target
 @return ZYTimer 对象
 */
+ (nonnull instancetype)timerWithTimeInterval:(NSTimeInterval)interval target:(nonnull id)aTarget selector:(nonnull SEL)aSelector repeats:(BOOL)repeats userInfo:(nullable id)userInfo lifeDependObject:(nullable id)lifeDependObject;


/**
 创建一个定时器

 @param interval 周期
 @param repeats 是否重复
 @param userInfo 用户信息
 @param lifeDependObject 定时器随着该对象的销毁而销毁，不能传空值
 @param block 回调的block
 @return ZYTimer 对象
 */
+ (nonnull instancetype)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats userInfo:(nullable id)userInfo lifeDependObject:(nonnull id)lifeDependObject block:(nonnull ZYCallbackBlock)block;

/**
 开始
 */
- (void)fire;

/**
 暂停
 */
- (void)pause;

/**
 销毁，调用该方法后不可重新 fire
 */
- (void)invalidate;

@end
