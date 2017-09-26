//
//  YKCalenderMenuBar.h
//  TestDemo
//
//  Created by 杨卡 on 2017/8/17.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YKCalenderMenuBarSelectBlock)(NSUInteger index);

@interface YKCalenderMenuBar : UIView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray*)items didSelectBlock:(YKCalenderMenuBarSelectBlock)block;

- (void)touchButtonAtIndex:(NSUInteger)index;

@end
