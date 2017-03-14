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

-(void)dealloc
{
    NSLog(@"GCDViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    /*
     1. block
     */
    
    __weak typeof(self) weakSelf = self;
    self.timer = [ZYGCDTimer timerWithTimeInterval:1.0 userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue() block:^(ZYGCDTimer * _Nonnull timer) {
        
        /*
         在 block 中写 NSAssert 会导致控制器无法释放。若要写 NSAssert，可以采取 target selector 的方式
         */
        //NSAssert(1, @"There is main thread");
        
        weakSelf.currentTime += timer.interval;
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%f",weakSelf.currentTime];
    }];
    
    
    
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

- (void)backgroundTimerCallback:(ZYGCDTimer *)timer
{
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
