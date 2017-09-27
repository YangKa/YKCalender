//
//  YKCalender_Header.h
//  TestDemo
//
//  Created by 杨卡 on 2017/8/17.
//  Copyright © 2017年 yangka. All rights reserved.
//

#ifndef YKCalender_Header_h
#define YKCalender_Header_h

#import <CoreGraphics/CoreGraphics.h>

#define YKCalenderColorRGB(R, G, B) [UIColor colorWithRed:(R/255.0) green:(G/255.0) blue:(B/255.0) alpha:1.0]

#define YKCalender_Color1 YKCalenderColorRGB(43, 43, 43)

#define YKCalender_Color2 YKCalenderColorRGB(80, 80, 80)

#define YKCalender_Color3 YKCalenderColorRGB(176, 176, 176)

#define YKCalender_RedColor1	YKCalenderColorRGB(238, 53, 51)

#define YKCalender_RedColor2	YKCalenderColorRGB(244, 126, 123)

#define YKCalender_BGColor1 YKCalenderColorRGB(240, 240, 240)

#define RandomColor   YKCalenderColorRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

static CGFloat padding = 10;

typedef enum : NSUInteger {
    YKCalenderType_day,
    YKCalenderType_month,
    YKCalenderType_quarter,
    YKCalenderType_year,
    YKCalenderType_region
} YKCalenderType;



#endif /* YKCalender_Header_h */
