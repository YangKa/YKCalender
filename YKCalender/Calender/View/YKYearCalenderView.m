//
//  YKYearCalenderView.m
//  YKCalender
//
//  Created by 杨卡 on 2017/9/26.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKYearCalenderView.h"

@interface YKYearCalenderView ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
}
@end

@implementation YKYearCalenderView

- (instancetype)initWithFrame:(CGRect)frame intervalYears:(NSUInteger)intervalYears delegate:(id)delegate{
    self = [super initWithFrame:frame intervalYears:intervalYears delegate:delegate];
    if (self) {
        [self layoutUI];
    }
    return self;
}

#pragma mark
#pragma mark layout UI
- (void)layoutUI{
    [self addTableView];
}

- (void)addTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = YKCalender_BGColor1;
    [self addSubview:tableView];
    _tableView = tableView;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark
#pragma mark delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.intervalYears;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = YKCalender_BGColor1;
        cell.textLabel.textColor = YKCalender_Color2;
        cell.textLabel.highlightedTextColor = YKCalender_RedColor1;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = [self rowTextForIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //选择日期
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSignleCalender:calenderType:)]) {
        NSUInteger curYear = self.startYear + self.intervalYears - 1 - indexPath.row;
        YKCalenderModel *model = [[YKCalenderModel alloc] initWithYear:curYear];
        [self.delegate didSelectSignleCalender:model calenderType:YKCalenderType_year];
    }
    
}

#pragma mark
#pragma mark event method
- (void)scrollToBeginCalender:(YKCalenderModel*)startModel endCalender:(YKCalenderModel*)endModel calenderType:(YKCalenderType)calenderType{
    [super scrollToBeginCalender:startModel endCalender:endModel calenderType:calenderType];
    if (calenderType != YKCalenderType_year) {
        return;
    }
    
    if (startModel) {
        NSUInteger section = 0;
        NSUInteger row = [YKDateTool curYear] - startModel.year;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark
#pragma mark private method
- (NSString*)rowTextForIndexPath:(NSIndexPath*)indexPath{
    
    NSUInteger curYear = self.startYear + self.intervalYears - 1 - indexPath.row;
    return [NSString stringWithFormat:@"  %lu年", (unsigned long)curYear];
}

@end

