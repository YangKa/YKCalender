//
//  YKDayCalenderView.m
//  YKCalender
//
//  Created by 杨卡 on 2017/9/26.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKDayCalenderView.h"

@interface YKDayCalenderView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end;

static CGFloat weakBarHeight = 30.0f;
static CGFloat sectionHeaderHeight = 35.0f;

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const sectionHeaderIdentifier = @"sectionHeaderIdentifier";

@implementation YKDayCalenderView

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
    if (@available(iOS 9.0, *)) {
        layout.sectionHeadersPinToVisibleBounds = YES;
    }
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
    return [self numberCellsForSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    
    UILabel *label = (UILabel*)[cell viewWithTag:100];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        label.highlightedTextColor = [UIColor whiteColor];
        label.textAlignment  =NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.tag = 100;
        [cell.contentView addSubview:label];
    }
    
    label.text = [self cellTextForIndexPath:indexPath];
    
    if ([self isFutureForIndex:indexPath]) {
        label.textColor = YKCalender_Color3;
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }else{
        BOOL isWeekEnd = ( (indexPath.row % 7 == 0) || (indexPath.row % 7 == 6) );
        label.textColor = isWeekEnd? YKCalender_RedColor1:YKCalender_Color2;
        cell.selectedBackgroundView.backgroundColor = (label.text.length == 0) ? [UIColor whiteColor]:YKCalender_RedColor1;
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
        view.backgroundColor = [UIColor whiteColor];
        
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
        //选择日期
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSignleCalender:calenderType:)]) {
            YKCalenderModel *model = [self calenderModelForIndex:indexPath];
            [self.delegate didSelectSignleCalender:model calenderType:YKCalenderType_day];
        }
    }
}

#pragma mark
#pragma mark event method
- (void)scrollToBeginCalender:(YKCalenderModel*)startModel endCalender:(YKCalenderModel*)endModel calenderType:(YKCalenderType)calenderType{
    [super scrollToBeginCalender:startModel endCalender:endModel calenderType:calenderType];
    if (calenderType != YKCalenderType_day) {
        return;
    }
    
    if (startModel) {
        NSIndexPath *indexPath = [self indexForCalender:startModel];
        [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    }
}

- (NSIndexPath*)indexForCalender:(YKCalenderModel*)model{
    NSUInteger weekDay = [YKDateTool weekDayForYear:model.year month:model.month day:1]-1;
    NSUInteger row = weekDay + model.day - 1;
    NSUInteger section = 0;
    if (model.year == self.endYear) {
        section = self.endMonth - model.month;
    }else{
        section = self.endMonth + (self.endYear - model.year - 1)*12 + (12 - model.month);
    }
    return [NSIndexPath indexPathForRow:row inSection:section];
}

#pragma mark
#pragma mark private method
//number cells for section
- (NSUInteger)numberCellsForSection:(NSUInteger)section{
    
    NSUInteger curYear = [self curYearForSection:section];
    NSUInteger curMonth = [self curMonthForSection:section];
    NSUInteger firstWeakDay = [YKDateTool weekDayForYear:curYear month:curMonth day:1] -1;
    return [YKDateTool daysForMonth:curMonth year:curYear] + firstWeakDay;
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

- (NSDate*)dateForIndexPath:(NSIndexPath*)indexPath{
    
    NSUInteger curYear = [self curYearForSection:indexPath.section];
    NSUInteger curMonth = [self curMonthForSection:indexPath.section];
    NSUInteger firstWeakDay = [YKDateTool weekDayForYear:curYear month:curMonth day:1] -1;
    NSUInteger day = indexPath.row - firstWeakDay + 1;
    return [YKDateTool dateForYear:curYear month:curMonth day:day];
}

- (BOOL)isFutureForIndex:(NSIndexPath*)indexPath{
    NSUInteger curYear = [self curYearForSection:indexPath.section];
    NSUInteger curMonth = [self curMonthForSection:indexPath.section];
    NSUInteger firstWeakDay = [YKDateTool weekDayForYear:curYear month:curMonth day:1] -1;
    NSUInteger curDay = indexPath.row - firstWeakDay + 1;
    
    return [YKDateTool isFutureCalenderForYear:curYear month:curMonth day:curDay];
}

#pragma mark
- (NSUInteger)curYearForSection:(NSUInteger)section{
    NSUInteger curYear;
    if (section < self.endMonth) {
        curYear  =self.endYear;
    }else{
        curYear = self.endYear - ((section - self.endMonth)/12 + 1);
    }
    return curYear;
}

- (NSUInteger)curMonthForSection:(NSUInteger)section{
    NSUInteger curMonth;
    if (section < self.endMonth) {
        curMonth = self.endMonth - section;
    }else{
        curMonth = 12 - (section - self.endMonth)%12;
    }
    return curMonth;
}
@end

