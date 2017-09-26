//
//  YKCalenderBaseView.h
//  YKCalender
//
//  Created by 杨卡 on 2017/9/26.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKCalenderProtocol.h"
#import "YKDateTool.h"
#import "YKCalenderModel.h"

@interface YKCalenderBaseView : UIView<YKCalenderScrollProtocol>

@property (nonatomic, readonly, weak) id<YKCalenderSelectProtocol> delegate;

@property (nonatomic, readonly, assign) NSUInteger intervalYears;

@property (nonatomic, readonly, assign) NSUInteger startYear;

@property (nonatomic, readonly, assign) NSUInteger endYear;

@property (nonatomic, readonly, assign) NSUInteger endMonth;

- (instancetype)initWithFrame:(CGRect)frame intervalYears:(NSUInteger)intervalYears delegate:(id)delegate;

@end
