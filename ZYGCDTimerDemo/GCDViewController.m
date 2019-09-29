//
//  GCDViewController.m
//  ZYGCDTimerDemo
//
//  GitHub https://github.com/ripperhe
//  Created by ripper on 2017/2/21.
//  Copyright © 2017年 ripper. All rights reserved.
//

#import "GCDViewController.h"
#import "ZYGCDTimer.h"

@interface GCDViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) ZYGCDTimer *timer;
@property (nonatomic, strong) ZYGCDTimer *backgroundTimer;

@property (nonatomic, strong) dispatch_queue_t backgroundQueue;

@property (nonatomic, assign) NSTimeInterval currentTime;;

@end

static const char *BackgroundTimerQueueContext = "BackgroundTimerQueueContext";

@implementation GCDViewController

-(void)dealloc {
    NSLog(@"%@ dealloc", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     1. block
     */
    
    __weak typeof(self) weakSelf = self;
    self.timer = [ZYGCDTimer timerWithTimeInterval:1.0 userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue() block:^(ZYGCDTimer * _Nonnull timer) {
        __strong typeof(weakSelf) self = weakSelf;
        
        // block 内部使用 self 都需要对 self 弱引用，否则会强持有
        // PS: NSAssert 宏内部使用了 self，所以用 NSAssert 也需要弱引用
        NSAssert(NSThread.isMainThread, @"不是主线程");
        self.currentTime += timer.interval;
        self.timeLabel.text = [NSString stringWithFormat:@"%f",self.currentTime];
    }];
    self.timer.tolerance = 0.5;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.timer.tolerance = 0.8;
    });
    /*
     2. target selector
     */
    
    self.backgroundQueue = dispatch_queue_create("com.ripperhe.backQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_set_specific(self.backgroundQueue, (__bridge const void *)(self), (void *)BackgroundTimerQueueContext, NULL);
    
    self.backgroundTimer = [ZYGCDTimer timerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(backgroundTimerCallback:)
                                                    userInfo:nil
                                                     repeats:YES
                                               dispatchQueue:self.backgroundQueue];
    [self.backgroundTimer fire];
}

- (void)backgroundTimerCallback:(ZYGCDTimer *)timer {
    NSAssert(![NSThread isMainThread], @"There is background thread");
    
    const BOOL result = dispatch_queue_get_specific(self.backgroundQueue, (__bridge const void *)(self)) == BackgroundTimerQueueContext;
    
    NSAssert(result, @"There should be my background queue");
    
    NSLog(@"background queue running ---->");
}


- (IBAction)fire:(id)sender {
    [self.timer fire];
}

- (IBAction)pause:(id)sender {
    [self.timer pause];
}

- (IBAction)invalidate:(id)sender {
    [self.timer invalidate];
}

@end
