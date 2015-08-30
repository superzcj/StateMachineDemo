//
//  ViewController.m
//  StateMachineDemo
//
//  Created by zhangchaojie on 15/8/29.
//  Copyright (c) 2015年 zcj. All rights reserved.
//

#import "ViewController.h"
//发射火箭的有三种状态，待机、计时、发射
typedef enum : NSUInteger {
    Standby,
    CountDown,
    Launch,
} State;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *rocketView;
@property (weak, nonatomic) IBOutlet UILabel *countDownLbl;
@property (weak, nonatomic) IBOutlet UIButton *fireBtn;
@property (weak, nonatomic) IBOutlet UIButton *abortBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rocketViewButtomSpaceConstraint;

@property (nonatomic) State currentState;
@property (nonatomic,strong) NSTimer *launchReadyTimer;
@property (nonatomic) NSInteger count;
@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - event response
- (IBAction)fire:(id)sender
{
    self.currentState = CountDown;
}

- (IBAction)abort:(id)sender
{
    self.currentState = Standby;
}

- (IBAction)refresh:(id)sender
{
    self.currentState = Standby;
}

-(void)countDownToFire:(NSTimer *)timer
{
    self.count--;
    if (self.count == 0)
    {
        [self.launchReadyTimer invalidate];
        self.launchReadyTimer = nil;
        
        self.currentState = Launch;
    }
}

#pragma mark - getters and setters
-(void)setCurrentState:(State)currentState
{
    _currentState = currentState;
    switch (currentState) {
        case Standby:
            self.countDownLbl.text = @"Standby";
            self.fireBtn.enabled = YES;
            self.abortBtn.enabled = NO;
            
            if (self.launchReadyTimer)
            {
                [self.launchReadyTimer invalidate];
                self.launchReadyTimer = nil;
            }

            self.rocketViewButtomSpaceConstraint.constant = 0;
            break;
        case CountDown:
            self.fireBtn.enabled = NO;
            self.abortBtn.enabled = YES;
            
            self.count = 5;
            self.launchReadyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownToFire:) userInfo:nil repeats:YES];
            break;
        case Launch:
            if (self.launchReadyTimer)
            {
                [self.launchReadyTimer invalidate];
                self.launchReadyTimer = nil;
            }

            self.countDownLbl.text = @"Launch";
            self.fireBtn.enabled = NO;
            self.abortBtn.enabled = NO;
            
            [UIView beginAnimations:@"RocketLaunch" context:nil];
            [UIView setAnimationDuration:3];
            
            self.rocketViewButtomSpaceConstraint.constant = self.view.bounds.size.height;
            [self.view layoutIfNeeded];
            
            [UIView commitAnimations];
            break;
        
        default:
            break;
    }
}

-(void)setCount:(NSInteger)count
{
    _count = count;
    self.countDownLbl.text = [NSString stringWithFormat:@"%ld", (long)_count];
}
@end
