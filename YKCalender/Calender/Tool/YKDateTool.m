//
//  YKDateTool.m
//  YKCalender
//
//  Created by 杨卡 on 2017/9/26.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKDateTool.h"

@implementation YKDateTool

#pragma mark
+ (NSUInteger)dayForDate:(NSDate*)date{
    return  [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
}

+ (NSUInteger)monthForDate:(NSDate*)date{
    return  [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:date];
}

+ (NSUInteger)yearForDate:(NSDate*)date{
    return  [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:date];
}

#pragma mark
+ (NSUInteger)curDay{
    return  [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:[NSDate date]];
}

+ (NSUInteger)curMonth{
    return  [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:[NSDate date]];
}

+ (NSUInteger)curYear{
    return  [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
}

+ (NSDate*)dateForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    dateComponents.month = month;
    dateComponents.year = year;
    dateComponents.hour = 12;
    dateComponents.second = 12;
    dateComponents.minute = 12;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [gregorianCalendar dateFromComponents:dateComponents];
}

#pragma mark
+ (NSUInteger)weekDayForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    dateComponents.month = month;
    dateComponents.year = year;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorianCalendar dateFromComponents:dateComponents];
    
    NSInteger weekday = [gregorianCalendar component:NSCalendarUnitWeekday fromDate:date];
    
    return weekday;
}

+ (NSUInteger)daysForMonth:(NSUInteger)month year:(NSUInteger)year{
    NSArray *list1 = @[@1, @3, @5, @7, @8, @10, @12];
    NSArray *list2 = @[@4, @6, @9, @11];
    
    NSUInteger days = 0;
    if ([list1 containsObject:[NSNumber numberWithInteger:month]]) {
        days = 31;
    }else if ([list2 containsObject:[NSNumber numberWithInteger:month]]) {
        days = 30;
    }else{
        if (year%4 == 0) {
            days = 29;
        }else{
            days = 28;
        }
    }
    
    NSUInteger firstWeakDay = [self weekDayForYear:year month:month day:1] -1;
    return days + firstWeakDay;
}

+ (BOOL)isFutureCalenderForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day{

    NSInteger curYear = [self curYear];
    NSInteger curMonth = [self curMonth];
    NSInteger curDay = [self curDay];
    
    if (year > curYear ||
        (year == curYear && month > curMonth) ||
        (year == curYear && month == curMonth && day > curDay)) {
        return YES;
    }
    
    return NO;
}
@end
