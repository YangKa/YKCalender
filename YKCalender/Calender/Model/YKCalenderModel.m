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

@end
