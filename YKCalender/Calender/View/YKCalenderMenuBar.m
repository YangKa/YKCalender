//
//  YKCalenderMenuBar.m
//  TestDemo
//
//  Created by 杨卡 on 2017/8/17.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKCalenderMenuBar.h"
#import "YKCalender_Header.h"

@interface YKCalenderMenuBar ()

@property (nonatomic, strong) UIView *line;

@property (nonatomic, assign) NSInteger curSelectIndex;

@property (nonatomic, copy) YKCalenderMenuBarSelectBlock selectBlock;

@end

static int basicTag = 10;
@implementation YKCalenderMenuBar

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray*)items didSelectBlock:(YKCalenderMenuBarSelectBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        _curSelectIndex = -1;
        _selectBlock = [block copy];
        
        [self layoutUIWithItems:items];
        
        [self touchButtonAtIndex:0];
    }
    return self;
}

- (void)layoutUIWithItems:(NSArray*)items{
    
    CGFloat width = (self.frame.size.width - 2*padding) / items.count;
    CGFloat lineHeihgt = 2;
    CGFloat height = self.frame.size.height - lineHeihgt;
    
    for (int i = 0; i < items.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(padding + width*i, 0, width, height)];
        [button setTitle:items[i] forState:UIControlStateNormal];
        [button setTitleColor:YKCalender_Color2 forState:UIControlStateNormal];
        [button setTitleColor:YKCalender_RedColor1 forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        button.tag = basicTag + i;
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, lineHeihgt)];
    line.backgroundColor = YKCalender_RedColor1;
    [self addSubview:line];
    self.line = line;
}
                                                
- (void)touchButton:(UIButton*)button{
    if( _selectBlock){
        _selectBlock(button.tag % basicTag);
    }
}

- (void)touchButtonAtIndex:(NSUInteger)index{
    
    index = index + 10;
    
    UIButton *button = (UIButton*)[self viewWithTag:index];
    CGFloat centerX = padding + button.frame.size.width*(index % basicTag + 0.5);
    
    [UIView animateWithDuration:0.3 animations:^{
        _line.center = CGPointMake(centerX, button.frame.size.height + _line.frame.size.height/2);
    } completion:^(BOOL finished) {
        
        if (_curSelectIndex >= 0) {
            UIButton *lastButton = (UIButton*)[self viewWithTag:_curSelectIndex];
            lastButton.selected = NO;
        }
        _curSelectIndex = index;
        button.selected = YES;
    }];
}

@end
