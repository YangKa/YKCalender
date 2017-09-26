//
//  YKDateTool.h
//  YKCalender
//
//  Created by 杨卡 on 2017/9/26.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKDateTool : NSObject

+ (NSUInteger)curDay;

+ (NSUInteger)curMonth;

+ (NSUInteger)curYear;


+ (NSUInteger)dayForDate:(NSDate*)date;

+ (NSUInteger)monthForDate:(NSDate*)date;

+ (NSUInteger)yearForDate:(NSDate*)date;

+ (NSDate*)dateForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

+ (NSUInteger)daysForMonth:(NSUInteger)month year:(NSUInteger)year;

+ (NSUInteger)weekDayForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

+ (BOOL)isFutureCalenderForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

@end
