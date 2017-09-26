//
//  YKResultCalenderModel.m
//  BQReport
//
//  Created by 杨卡 on 2017/9/18.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKResultCalenderModel.h"

@interface YKResultCalenderModel ()

@end

@implementation YKResultCalenderModel

+ (instancetype)resultCalenderWithStart:(YKCalenderModel*)startCalender end:(YKCalenderModel*)endCalender type:(YKCalenderType)type{
    YKResultCalenderModel *model = [[YKResultCalenderModel alloc] init];
    model.selectCalenderType = type;
    model.startCalender = startCalender;
    model.endCalender = endCalender;
    return model;
}

@end
