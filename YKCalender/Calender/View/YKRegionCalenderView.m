//
//  YKRegionCalenderView.m
//  YKCalender
//
//  Created by 杨卡 on 2017/9/26.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKRegionCalenderView.h"

@interface YKRegionCalenderView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong)  NSIndexPath *startIndexPath;

@property (nonatomic, strong)  NSIndexPath *endIndexPath;

@end

static CGFloat weakBarHeight = 30.0f;
static CGFloat sectionHeaderHeight = 35.0f;

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const sectionHeaderIdentifier = @"sectionHeaderIdentifier";
@implementation YKRegionCalenderView

#pragma mark
#pragma mark layout UI
- (void)layoutUI{
    [self addWeakBar];
    [self addCollectionView];
}

- (void)addWeakBar{
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, weakBarHeight)];
    barView.backgroundColor = YKCalender_BGColor1;
    [self addSubview:barView];
    
    NSArray *items = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    NSUInteger width = (self.frame.size.width - 2*padding) / items.count;
    CGFloat newPadding = (self.frame.size.width - 7*width)/2;
    for (int i =0; i < items.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(newPadding + i*width, 0, width, barView.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = YKCalender_Color3;
        label.text = items[i];
        [barView addSubview:label];
    }
}

- (void)addCollectionView{
    
    NSUInteger itemWidth = (self.frame.size.width - 2*padding) / 7;
    CGFloat newPadding = (self.frame.size.width - 7*itemWidth)/2;
    CGFloat itemHeight = itemWidth + 20;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(self.frame.size.width, sectionHeaderHeight);
    layout.sectionInset = UIEdgeInsetsMake(0, newPadding, 5, newPadding);
    
    CGRect frame = CGRectMake(0, weakBarHeight, self.frame.size.width, self.frame.size.height - weakBarHeight);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderIdentifier];
}

#pragma mark
#pragma mark delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 12*(self.intervalYears-1) + self.endMonth;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSUInteger days = [self numberCellsForSection:section];
    if (days %7 > 0){
        days = days - (days%7) + 7;
    }
    return days;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = (UILabel*)[cell viewWithTag:100];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        label.textAlignment  =NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.tag = 100;
        [cell.contentView addSubview:label];
    }
    
    label.text = [self cellTextForIndexPath:indexPath];
    
    //is select
    NSInteger selectType = [self containInSelectRegionForIndexPath:indexPath];
    if (selectType == -1) {
        
        if ([self isFutureForIndex:indexPath]) {
            label.textColor = YKCalender_Color3;
        }else{
            //is week end
            BOOL isWeekEnd = ( (indexPath.row % 7 == 0) || (indexPath.row % 7 == 6) );
            label.textColor = isWeekEnd? YKCalender_RedColor1:YKCalender_Color2;
        }
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        label.textColor = [UIColor whiteColor];
        cell.backgroundColor = (selectType == 1) ? YKCalender_RedColor1:YKCalender_RedColor2;
    }
    
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView;
    if(kind == UICollectionElementKindSectionFooter){
        reusableView = nil;
    }
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionHeaderIdentifier forIndexPath:indexPath];
        
        UIView *line = (UIView*)[view viewWithTag:101];
        UILabel *label = (UILabel*)[view viewWithTag:102];
        if (!line) {
            line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 1)];
            line.backgroundColor = YKCalender_BGColor1;
            line.tag = 101;
            [view addSubview:line];
        }
        
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width, sectionHeaderHeight)];
            label.textColor = YKCalender_Color1;
            label.tag = 102;
            label.textAlignment  =NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:15];
            [view addSubview:label];
        }
        label.text = [self sectionTextForIndexPath:indexPath];
        
        reusableView = view;
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *label = (UILabel*)[cell viewWithTag:100];
    if (label.text.length == 0 || [self isFutureForIndex:indexPath]) {
        
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }else{
        
        //重新选择
        if (!_startIndexPath){
            _startIndexPath = indexPath;
            _endIndexPath = nil;
        }else if (_startIndexPath && !_endIndexPath){
            _endIndexPath = indexPath;
            [self exchangeIndexPath];
        }else if (_startIndexPath && _endIndexPath){
            _startIndexPath = indexPath;
            _endIndexPath = nil;
        }
        
        [self highlightAllSelectRows];
        
        if (_startIndexPath && _endIndexPath) {
            [self performSelector:@selector(callBackSelectResult) withObject:nil afterDelay:0.5];
        }
    }
}

#pragma mark
#pragma mark public method
- (void)scrollToBeginCalender:(YKCalenderModel*)startModel endCalender:(YKCalenderModel*)endModel calenderType:(YKCalenderType)calenderType{
    
    if (calenderType != YKCalenderType_region) {
        return;
    }
    
    if (startModel && endModel) {
        _startIndexPath = [self indexPathForCalender:startModel];
        _endIndexPath = [self indexPathForCalender:endModel];
        
        [self highlightAllSelectRows];
        [_collectionView scrollToItemAtIndexPath:_startIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        
    }else{
        CGFloat positionY = _collectionView.contentSize.height - _collectionView.frame.size.height;
        [_collectionView setContentOffset:CGPointMake(0, positionY) animated:NO];
    }
}

- (NSIndexPath*)indexPathForCalender:(YKCalenderModel*)model{
    
    NSUInteger weekDay = [YKDateTool weekDayForYear:model.year month:model.month day:1] - 1;
    NSUInteger row = weekDay + model.day - 1;
    
    NSUInteger startYear = self.endYear - self.intervalYears + 1;
    NSUInteger section = (model.year - startYear)*12 + (model.month - 1);
    
    return  [NSIndexPath indexPathForRow:row inSection:section];
}

#pragma mark
#pragma mark event method
- (void)highlightAllSelectRows{
    [_collectionView reloadData];
}

- (NSInteger)containInSelectRegionForIndexPath:(NSIndexPath*)indexPath{
    if (_startIndexPath && (NSOrderedSame == [indexPath compare:_startIndexPath])) {
        return 1;
    }
    
    if (_endIndexPath && (NSOrderedSame == [indexPath compare:_endIndexPath])) {
        return 1;
    }
    
    if (_startIndexPath && _endIndexPath) {
        
        BOOL flag1 = (NSOrderedDescending == [indexPath compare:_startIndexPath]);
        BOOL flag2 = (NSOrderedAscending == [indexPath compare:_endIndexPath]);
        if (flag1 && flag2) {
            return 0;
        }
    }
    
    return -1;
}

- (void)exchangeIndexPath{
    if (NSOrderedDescending == [_startIndexPath compare:_endIndexPath]) {
        NSIndexPath *indexPath = _startIndexPath;
        _startIndexPath = _endIndexPath;
        _endIndexPath = indexPath;
    }
}

- (void)callBackSelectResult{
    //选择日期
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectMutileCalender:endCalender:)]) {
        YKCalenderModel *startModel = [self calenderModelForIndex:_startIndexPath];
        YKCalenderModel *endModel = [self calenderModelForIndex:_endIndexPath];
        [self.delegate didSelectMutileCalender:startModel endCalender:endModel];
    }
}

#pragma mark
#pragma mark private method
//number cells for section
- (NSUInteger)numberCellsForSection:(NSUInteger)section{
    
    NSUInteger curYear = [self curYearForSection:section];
    NSUInteger curMonth = [self curMonthForSection:section];
    
    NSUInteger monthDays = [YKDateTool daysForMonth:curMonth year:curYear];
    NSUInteger firstWeakDay = [YKDateTool weekDayForYear:curYear month:curMonth day:1] -1;
    
    return monthDays + firstWeakDay;
}

//section header text
- (NSString*)sectionTextForIndexPath:(NSIndexPath*)indexPath{
    
    NSUInteger curYear = [self curYearForSection:indexPath.section];
    NSUInteger curMonth = [self curMonthForSection:indexPath.section];
    
    return [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)curYear, curMonth];
}

//cell text
- (NSString*)cellTextForIndexPath:(NSIndexPath*)indexPath{
    
    NSUInteger curYear = [self curYearForSection:indexPath.section];
    NSUInteger curMonth = [self curMonthForSection:indexPath.section];
    NSUInteger firstWeakDay = [YKDateTool weekDayForYear:curYear month:curMonth day:1] -1;
    
    if (indexPath.row < 7 && indexPath.row < firstWeakDay) {
        return @"";
    }
    
    NSUInteger day = indexPath.row - firstWeakDay + 1;
    
    if (day > [YKDateTool daysForMonth:curMonth year:curYear]) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%lu", (unsigned long)day];
}

//date for cell
- (YKCalenderModel*)calenderModelForIndex:(NSIndexPath*)indexPath{
    NSUInteger curYear = [self curYearForSection:indexPath.section];
    NSUInteger curMonth = [self curMonthForSection:indexPath.section];
    NSUInteger firstWeakDay = [YKDateTool weekDayForYear:curYear month:curMonth day:1] -1;
    NSUInteger day = indexPath.row - firstWeakDay + 1;
    return [[YKCalenderModel alloc] initWithYear:curYear month:curMonth day:day];
}

//date for cell
- (NSDate*)dateForIndexPath:(NSIndexPath*)indexPath{
    NSUInteger curYear = [self curYearForSection:indexPath.section];
    NSUInteger curMonth = [self curMonthForSection:indexPath.section];
    NSUInteger firstWeakDay = [YKDateTool weekDayForYear:curYear month:curMonth day:1] -1;
    NSUInteger day = indexPath.row - firstWeakDay + 1;
    return  [YKDateTool dateForYear:curYear month:curMonth day:day];
}

- (BOOL)isFutureForIndex:(NSIndexPath*)indexPath{
    //date for indexPath
    NSUInteger curYear = [self curYearForSection:indexPath.section];
    NSUInteger curMonth = [self curMonthForSection:indexPath.section];
    NSUInteger firstWeakDay = [YKDateTool weekDayForYear:curYear month:curMonth day:1] -1;
    NSUInteger curDay = indexPath.row - firstWeakDay + 1;
    
    return [YKDateTool isFutureCalenderForYear:curYear month:curMonth day:curDay];
}

#pragma mark
- (NSUInteger)curYearForSection:(NSUInteger)section{
    NSUInteger startYear = self.endYear - self.intervalYears + 1;
    return startYear + section/12;
}

- (NSUInteger)curMonthForSection:(NSUInteger)section{
    return section%12 + 1;
}

@end


