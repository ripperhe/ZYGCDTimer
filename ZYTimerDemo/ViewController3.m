//
//  ViewController3.m
//  ZYTimerDemo
//
//  GitHub https://github.com/ripperhe
//  Created by ripper on 2017/2/20.
//  Copyright © 2017年 ripper. All rights reserved.
//

#import "ViewController3.h"
#import "ZYGCDTimer.h"

@interface ViewController3 ()

@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@property (nonatomic, strong) dispatch_source_t tt;

@property (nonatomic, strong) ZYGCDTimer *timer;

@property (nonatomic, assign) NSTimeInterval currentTime;


@end

@implementation ViewController3


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timer = [ZYGCDTimer timerWithTimeInterval:0.1 target:self selector:@selector(refresh) userInfo:nil repeats:YES dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    
    self.timer = [ZYGCDTimer timerWithTimeInterval:0.1 userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue() block:^(ZYGCDTimer * _Nonnull timer, NSTimeInterval currentTime, NSInteger repeatCount) {
       
        NSLog(@"cout:%zd time: %f", repeatCount, currentTime);
        
    }];
}


- (void)refresh
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentTime ++;
        self.timelabel.text = [NSString stringWithFormat:@"%f", self.currentTime];
    });
}



- (IBAction)start:(id)sender {
    [self.timer fire];
}

- (IBAction)pause:(id)sender {
    [self.timer pause];
}

- (IBAction)invalidate:(id)sender {
    [self.timer invalidate];
}





- (void)test
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    self.tt = timer;
    
    
    /*
     dispatch_time(dispatch_time_t when, int64_t delta)
     
     DISPATCH_TIME_NOW 是当前时间，开始时间的话，应该设置为当前时间再偏移一个周期，这样定时器才不会立即回调，delta 设置为一个周期即可。
     
     delta 的单位是 Nanoseconds，即为纳秒，所以需要用秒乘以 NSEC_PER_SEC (多少纳秒每秒)
     */
    uint64_t interval = 1 * NSEC_PER_SEC;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, interval);
    
    dispatch_source_set_timer(timer, time, interval, 0.1 * NSEC_PER_SEC);
    
    
    dispatch_source_set_event_handler(timer, ^{
        
        NSLog(@"1111");
        
    });
    
    NSLog(@"开工");
    dispatch_resume(timer);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"收工");
        dispatch_source_cancel(self.tt);
        self.tt = nil;
    });

}


@end
