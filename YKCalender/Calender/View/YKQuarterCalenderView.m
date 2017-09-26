//
//  YKQuarterCalenderView.m
//  YKCalender
//
//  Created by 杨卡 on 2017/9/26.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKQuarterCalenderView.h"

@interface YKQuarterCalenderView ()<UITableViewDelegate, UITableViewDataSource>{
    NSUInteger _curSelectSection;
}

@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UITableView *rigthTableView;

@end

static CGFloat leftTableViewWidth = 100.0f;

@implementation YKQuarterCalenderView

- (instancetype)initWithFrame:(CGRect)frame intervalYears:(NSUInteger)intervalYears delegate:(id)delegate{
    self = [super initWithFrame:frame intervalYears:intervalYears delegate:delegate];
    if (self) {
        [self layoutUI];
        
        [self selectLeftTableViewForRow:0];
    }
    return self;
}

#pragma mark
#pragma mark layout UI
- (void)layoutUI{
    [self addLeftTableView];
    [self addRightTableView];
}

- (void)addLeftTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, leftTableViewWidth, self.frame.size.height) style:UITableViewStylePlain];
    tableView.tag = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = YKCalender_BGColor1;
    [self addSubview:tableView];
    self.leftTableView = tableView;
}

- (void)addRightTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(leftTableViewWidth, 0, self.frame.size.width - leftTableViewWidth, self.frame.size.height) style:UITableViewStylePlain];
    tableView.tag = 1;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tableView];
    self.rigthTableView = tableView;
}

#pragma mark
#pragma mark delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 0) {
        return 1;
    }else{
        return self.intervalYears;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return self.intervalYears;
    }else{
        return [self monthsForSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return 0.1;
    }else{
        return 30;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return @"";
    }else{
        return [self sectionTextForSection:section];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = tableView.tag == 0 ? @"leftCell":@"rightCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        if (tableView.tag == 0) {
            cell.backgroundColor = YKCalender_BGColor1;
            cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        }else{
            cell.selectedBackgroundView.backgroundColor = YKCalender_BGColor1;
        }
        cell.textLabel.textColor = YKCalender_Color2;
        cell.textLabel.highlightedTextColor = YKCalender_RedColor1;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    if (tableView.tag == 0) {
        cell.textLabel.text = [self sectionTextForSection:indexPath.row];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld季度", indexPath.row+1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0 && indexPath.row != _curSelectSection) {
        
        NSIndexPath *rowPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        [_rigthTableView scrollToRowAtIndexPath:rowPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else{
        
        //选择日期
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSignleCalender:calenderType:)]) {
            YKCalenderModel *model = [self calenderModelForIndex:indexPath];
            [self.delegate didSelectSignleCalender:model calenderType:YKCalenderType_quarter];
        }
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 1){
        NSUInteger section = [[_rigthTableView indexPathForCell:[_rigthTableView visibleCells].firstObject] section];
        [self selectLeftTableViewForRow:section];
    }
}

#pragma mark
#pragma mark event method
- (void)scrollToBeginCalender:(YKCalenderModel*)startModel endCalender:(YKCalenderModel*)endModel calenderType:(YKCalenderType)calenderType{
    if (calenderType != YKCalenderType_quarter) {
        return;
    }
    
    if (startModel) {
        NSIndexPath *indexPath = [self indexPathForCalender:startModel];
        [_rigthTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (NSIndexPath*)indexPathForCalender:(YKCalenderModel*)model{
    NSUInteger section = [YKDateTool curYear] - model.year;
    NSUInteger row = model.quarter - 1;
    return  [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)selectLeftTableViewForRow:(NSUInteger)index{
    _curSelectSection = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_curSelectSection inSection:0];
    [_leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark
#pragma mark private method
//date for cell
- (YKCalenderModel*)calenderModelForIndex:(NSIndexPath*)indexPath{
    NSUInteger curYear = self.startYear + self.intervalYears - 1 - indexPath.section;
    NSUInteger quarter = indexPath.row + 1;
    
    return [[YKCalenderModel alloc] initWithYear:curYear quarter:quarter];
}

//number cell for section
- (NSUInteger)monthsForSection:(NSUInteger)section{
    if (section == 0) {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger month = [gregorianCalendar component:NSCalendarUnitMonth fromDate:[NSDate date]];
        return (month-1)/3+1;
        
    }
    return 4;
}

//section header text
- (NSString*)sectionTextForSection:(NSUInteger)section{
    
    NSUInteger curYear = self.startYear + self.intervalYears -1 - section;
    return [NSString stringWithFormat:@"%lu年", (unsigned long)curYear];
}

@end

