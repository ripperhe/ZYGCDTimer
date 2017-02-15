//
//  ViewController2.m
//  ZYTimerDemo
//
//  GitHub https://github.com/ripperhe
//  Created by ripper on 2017/2/15.
//  Copyright © 2017年 ripper. All rights reserved.
//

#import "ViewController2.h"
#import "ZYTimer.h"
#import "ZYTest.h"

@interface ViewController2 ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, assign) NSTimeInterval time;

@property (nonatomic, strong) ZYTimer *timer;


@end


static ZYTest *_obj = nil;

@implementation ViewController2


- (void)dealloc
{
    NSLog(@"ViewController2 dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _obj = [[ZYTest alloc] init];
    
    ZYTimer *timer = [ZYTimer timerWithTimeInterval:1 target:self selector:@selector(ceshi) repeats:YES lifeDependObject:self];
    
    
//    ZYTimer *timer = [ZYTimer timerWithTimeInterval:3 repeats:YES lifeDependObject:self block:^(ZYTimer * _Nonnull timer, NSTimeInterval currentTime) {
//        NSLog(@"%f", currentTime);
//    }];
    
    
    self.timer = timer;
    
    
    
}

- (void)ceshi
{
    self.time ++ ;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%f", self.time];
}


- (IBAction)start:(id)sender {
    [self.timer fire];
}
- (IBAction)pause:(id)sender {
    [self.timer pause];
}
- (IBAction)destroy:(id)sender {
    [self.timer invalidate];
}

@end
