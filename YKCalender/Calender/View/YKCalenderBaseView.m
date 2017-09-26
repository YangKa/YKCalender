//
//  YKCalenderBaseView.m
//  YKCalender
//
//  Created by 杨卡 on 2017/9/26.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKCalenderBaseView.h"


@interface YKCalenderBaseView ()

@property (nonatomic, weak) id<YKCalenderSelectProtocol> delegate;

@property (nonatomic, assign) NSUInteger intervalYears;

@property (nonatomic, assign) NSUInteger startYear;

@property (nonatomic, assign) NSUInteger endYear;

@property (nonatomic, assign) NSUInteger endMonth;

@end

@implementation YKCalenderBaseView

- (instancetype)initWithFrame:(CGRect)frame intervalYears:(NSUInteger)intervalYears delegate:(id)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _delegate  = delegate;
        _intervalYears = intervalYears;
        _startYear = [YKDateTool curYear] - _intervalYears + 1;
        _endYear = [YKDateTool curYear];
        _endMonth = [YKDateTool curMonth];
    }
    return self;
}

- (void)scrollToBeginCalender:(YKCalenderModel*)startModel endCalender:(YKCalenderModel*)endModel calenderType:(YKCalenderType)calenderType{
    
}

@end
