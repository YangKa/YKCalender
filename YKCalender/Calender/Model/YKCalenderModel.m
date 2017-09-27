//
//  YKCalenderModel.m
//  TestDemo
//
//  Created by 杨卡 on 2017/8/18.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKCalenderModel.h"

@implementation YKCalenderModel

- (instancetype)initWithYear:(NSUInteger)year{
    return [self initWithYear:year quarter:-1 month:-1 day:-1];
}

- (instancetype)initWithYear:(NSUInteger)year quarter:(NSUInteger)quarter{
	return [self initWithYear:year quarter:quarter month:-1 day:-1];
}

- (instancetype)initWithYear:(NSUInteger)year month:(NSUInteger)month{
	return [self initWithYear:year quarter:-1 month:month day:-1];
}

- (instancetype)initWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day{
	return [self initWithYear:year quarter:-1 month:month day:day];
}

- (instancetype)initWithYear:(NSUInteger)year quarter:(NSUInteger)quarter month:(NSUInteger)month day:(NSUInteger)day{
    self = [super init];
    if (self) {
        self.year = year;
        self.quarter = quarter;
        self.month = month;
        self.day = day;
    }
    return self;
}

- (NSString*)dateTextForCalenderType:(YKCalenderType)type{
    
    if (!self) {
        NSLog(@"日期为空");
        return @"";
    }
    
    NSString *dateText;
    switch (type) {
        case YKCalenderType_day:{
            dateText = [NSString stringWithFormat:@"%ld-%02ld-%02ld", self.year, self.month, self.day];
        }break;
        case YKCalenderType_month:{
            dateText = [NSString stringWithFormat:@"%ld-%02ld", self.year, self.month];
        }break;
        case YKCalenderType_quarter:{
            dateText = [NSString stringWithFormat:@"%ld-%02ld", self.year, self.quarter];
        }break;
        case YKCalenderType_year:{
            dateText = [NSString stringWithFormat:@"%ld", self.year];
        }break;
        case YKCalenderType_region:{
            dateText = [NSString stringWithFormat:@"%ld-%02ld-%02ld", self.year, self.month, self.day];
        }break;
    }
    return dateText;
}

@end
