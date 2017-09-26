//
//  YKCalenderSelectProtocol.h
//  TestDemo
//
//  Created by 杨卡 on 2017/8/18.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKCalender_Header.h"

@protocol YKCalenderSelectProtocol <NSObject>

- (void)didSelectSignleCalender:(YKCalenderModel*)model calenderType:(YKCalenderType)calenderType;

- (void)didSelectMutileCalender:(YKCalenderModel*)startModel endCalender:(YKCalenderModel*)endCalender;

@end

@protocol YKCalenderScrollProtocol <NSObject>

@optional
- (void)scrollToBeginCalender:(YKCalenderModel*)startModel endCalender:(YKCalenderModel*)endModel calenderType:(YKCalenderType)calenderType;

@end
