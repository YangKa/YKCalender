//
//  YKCalenderModel.h
//  TestDemo
//
//  Created by 杨卡 on 2017/8/18.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKCalenderModel : NSObject

@property (nonatomic, assign) NSUInteger year;

//季度
@property (nonatomic, assign) NSUInteger quarter;

@property (nonatomic, assign) NSUInteger month;

@property (nonatomic, assign) NSUInteger day;

- (instancetype)initWithYear:(NSUInteger)year;

- (instancetype)initWithYear:(NSUInteger)year quarter:(NSUInteger)quarter;

- (instancetype)initWithYear:(NSUInteger)year month:(NSUInteger)month;

- (instancetype)initWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

@end
