//
//  YKResultCalenderModel.h
//  BQReport
//
//  Created by 杨卡 on 2017/9/18.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKCalenderModel.h"
#import "YKCalender_Header.h"

@interface YKResultCalenderModel : NSObject

@property (nonatomic, assign) YKCalenderType selectCalenderType;

@property (nonatomic, strong) YKCalenderModel *startCalender;

@property (nonatomic, strong) YKCalenderModel *endCalender;

+ (instancetype)resultCalenderWithStart:(YKCalenderModel*)startCalender end:(YKCalenderModel*)endCalender type:(YKCalenderType)type;

@end
