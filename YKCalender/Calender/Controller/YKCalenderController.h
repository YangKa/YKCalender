//
//  YKCalenderMainController.h
//  TestDemo
//
//  Created by 杨卡 on 2017/8/17.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKResultCalenderModel.h"
#import "YKCalenderBaseView.h"

typedef void(^YKCalenderDidSelectBlock)(BOOL selected, YKCalenderType calenderType, YKCalenderModel *startModel, YKCalenderModel *endModel);

@interface YKCalenderController : UIViewController

- (instancetype)initWithIntervalYears:(NSUInteger)intervalYears
                         defaultCalender:(YKResultCalenderModel*)result
                       selectComplete:(YKCalenderDidSelectBlock)selectBlock;

@end
