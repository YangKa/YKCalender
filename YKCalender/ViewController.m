//
//  ViewController.m
//  YKCalender
//
//  Created by 杨卡 on 2017/9/26.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "ViewController.h"
#import "YKCalenderController.h"

@interface ViewController (){
    
    YKCalenderModel *_startModel;
    YKCalenderModel *_endModel;
    YKCalenderType _calenderType;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    YKResultCalenderModel *result = [YKResultCalenderModel resultCalenderWithStart:_startModel end:_endModel type:_calenderType];
    
    YKCalenderController *VC = [[YKCalenderController alloc] initWithIntervalYears:4 defaultCalender:result selectComplete:^(BOOL selected, YKCalenderType calenderType, YKCalenderModel *startModel, YKCalenderModel *endModel) {
        
        if (selected) {
            
            _calenderType = calenderType;
            _startModel = startModel;
            _endModel = endModel;
            
            NSString *startDate = [startModel dateTextForCalenderType:calenderType];
            NSLog(@"startDate=%@", startDate);
            if (calenderType == YKCalenderType_region) {
                NSString *endDate = [endModel dateTextForCalenderType:calenderType];
                NSLog(@"endDate=%@", endDate);
            }
        }
    }];
    [self presentViewController:VC animated:YES completion:nil];
}

@end
