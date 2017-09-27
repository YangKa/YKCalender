//
//  YKCalenderController.m
//  TestDemo
//
//  Created by 杨卡 on 2017/8/17.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "YKCalenderController.h"
#import "YKCalender_Header.h"
#import "YKCalenderMenuBar.h"
#import "YKCalenderProtocol.h"


@interface YKCalenderController ()<UIScrollViewDelegate, YKCalenderSelectProtocol>{
    NSArray *_pageList;
    NSUInteger _intervalYears;
}

@property (nonatomic, strong) NSMutableArray *pageViewList;

@property (nonatomic, strong) YKCalenderMenuBar *menuBar;

@property (nonatomic, strong) UIScrollView *pageScorllView;

@property (nonatomic, copy) YKCalenderDidSelectBlock selectBlock;

@property (nonatomic, strong) YKResultCalenderModel* resultModel;

@end

static CGFloat const NavHeight = 64.0f;
static CGFloat const MenuBarHeight = 50.0f;

@implementation YKCalenderController

#pragma mark
#pragma mark life cycle
- (instancetype)initWithIntervalYears:(NSUInteger)intervalYears defaultCalender:(YKResultCalenderModel*)result selectComplete:(YKCalenderDidSelectBlock)selectBlock{
    self = [super init];
    if (self) {
        _selectBlock = [selectBlock copy];
        _intervalYears = intervalYears;
        _resultModel = result;
        _pageViewList = [NSMutableArray array];
        
        _pageList = @[@{@"title":@"日",
                       @"className":@"YKDayCalenderView"},
                     @{@"title":@"月",
                       @"className":@"YKMonthCalenderView"},
                     @{@"title":@"季度",
                       @"className":@"YKQuarterCalenderView"},
                     @{@"title":@"年",
                       @"className":@"YKYearCalenderView"},
                     @{@"title":@"自定义",
                       @"className":@"YKRegionCalenderView"}
                     ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择日期";
    
    [self layoutUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self p_scrollToSelectRegion];
}

#pragma mark
#pragma mark layout UI
- (void)layoutUI{
    [self addNavigationBar];
    [self addChildrenPages];
}

- (void)addNavigationBar{
    
    UIView *backBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, NavHeight)];
    [self.view addSubview:backBarView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectiveView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectiveView.frame = backBarView.bounds;
    [backBarView addSubview:effectiveView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
    [button setImage:[UIImage imageNamed:@"YKCalender_dismiss"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dimiss) forControlEvents:UIControlEventTouchUpInside];
    [backBarView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = @"选择日期";
    label.center = CGPointMake(effectiveView.frame.size.width/2, 42);
    label.textColor = YKCalender_Color1;
    label.textAlignment = NSTextAlignmentCenter;
    [backBarView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, effectiveView.frame.size.height-1, effectiveView.frame.size.width, 1)];
    line.backgroundColor = YKCalender_BGColor1;
    [backBarView addSubview:line];
}

- (void)addChildrenPages{
    
    //标题
    NSMutableArray *titles = [NSMutableArray array];
    for (int i =0; i < _pageList.count; i++) {
        NSDictionary *pageDic = _pageList[i];
        [titles addObject:pageDic[@"title"]];
    }
    CGRect frame = CGRectMake(0, NavHeight, self.view.frame.size.width, MenuBarHeight);
    __weak typeof(self) weakSelf = self;
    YKCalenderMenuBar *menuBar = [[YKCalenderMenuBar alloc] initWithFrame:frame items:titles didSelectBlock:^(NSUInteger index) {
        [weakSelf scrollToPageIndex:index];
    }];
    [self.view addSubview:menuBar];
    self.menuBar = menuBar;
    
    //页签
    CGFloat pageWidth = self.view.frame.size.width;
    CGFloat pageHeight = self.view.frame.size.height - CGRectGetMaxY(_menuBar.frame);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_menuBar.frame), pageWidth, pageHeight)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.pageScorllView = scrollView;
    
    for (int i =0; i < _pageList.count; i++) {
        NSDictionary *pageDic = _pageList[i];
        
        Class class = NSClassFromString(pageDic[@"className"]);
        YKCalenderBaseView *calenderView = [[class alloc] initWithFrame:CGRectMake(pageWidth*i, 0, pageWidth, pageHeight) intervalYears:_intervalYears delegate:self];
        [scrollView addSubview:calenderView];
        [_pageViewList addObject:calenderView];
    }
    scrollView.contentSize = CGSizeMake(pageWidth*_pageList.count, 0);
}

/*
- (void)addChildrenPages{
    
    CGFloat pageWidth = self.view.frame.size.width;
    CGFloat pageHeight = self.view.frame.size.height - CGRectGetMaxY(_menuBar.frame);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_menuBar.frame), pageWidth, pageHeight)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.pageScorllView = scrollView;
    
    NSArray *classList = @[@"YKDayCalenderView", @"YKMonthCalenderView", @"YKQuarterCalenderView", @"YKYearCalenderView", @"YKRegionCalenderView"];
    for (int i =0; i < classList.count; i++) {
        Class class = NSClassFromString(classList.firstObject);
        YKCalenderBaseView *calenderView = [[class alloc] initWithFrame:CGRectMake(pageWidth*i, 0, pageWidth, pageHeight) intervalYears:_intervalYears delegate:self];
        [scrollView addSubview:calenderView];
        [_pageViewList addObject:calenderView];
    }
    scrollView.contentSize = CGSizeMake(pageWidth*classList.count, 0);

//    YKDayCalenderView *dayCalenderView = [[YKDayCalenderView alloc] initWithFrame:CGRectMake(0, 0, pageWidth, pageHeight)
//                                                                    intervalYears:_intervalYears
//                                                                         delegate:self];
//    [scrollView addSubview:dayCalenderView];
//    [_pageViewList addObject:dayCalenderView];
//
//    YKMonthCalenderView *monthCalenderView = [[YKMonthCalenderView alloc] initWithFrame:CGRectMake(pageWidth, 0, pageWidth, pageHeight)
//                                                                          intervalYears:_intervalYears
//                                                                               delegate:self];
//    [scrollView addSubview:monthCalenderView];
//    [_pageViewList addObject:monthCalenderView];
//
//    YKQuarterCalenderView *quarterCalenderView = [[YKQuarterCalenderView alloc] initWithFrame:CGRectMake(2*pageWidth, 0, pageWidth, pageHeight)
//                                                                                intervalYears:_intervalYears
//                                                                                     delegate:self];
//    [scrollView addSubview:quarterCalenderView];
//    [_pageViewList addObject:quarterCalenderView];
//
//    YKYearCalenderView *yearCalenderView = [[YKYearCalenderView alloc] initWithFrame:CGRectMake(3*pageWidth, 0, pageWidth, pageHeight)
//                                                                       intervalYears:_intervalYears
//                                                                            delegate:self];
//    [scrollView addSubview:yearCalenderView];
//    [_pageViewList addObject:yearCalenderView];
//
////    YKCustomCalenderView *customCalenderView = [[YKCustomCalenderView alloc] initWithFrame:CGRectMake(4*pageWidth, 0, pageWidth, pageHeight)
////                                                                             intervalYears:_intervalYears
////                                                                                  delegate:self];
////    [scrollView addSubview:customCalenderView];
////    [_pageViewList addObject:customCalenderView];
//
//
//    scrollView.contentSize = CGSizeMake(pageWidth*5, 0);
}
 */

#pragma mark
#pragma mark Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSUInteger pageIndex = (scrollView.contentOffset.x +  scrollView.frame.size.width/2) / scrollView.frame.size.width;
    [_menuBar touchButtonAtIndex:pageIndex];
}

#pragma mark Delegate
- (void)didSelectSignleCalender:(YKCalenderModel*)model calenderType:(YKCalenderType)calenderType{
    if (_selectBlock) {
        _selectBlock(YES, calenderType, model, nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectMutileCalender:(YKCalenderModel*)startModel endCalender:(YKCalenderModel*)endCalender{
    if (_selectBlock) {
        _selectBlock(YES, YKCalenderType_region, startModel, endCalender);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark event method
- (void)scrollToPageIndex:(NSUInteger)pageIndex{
    [_pageScorllView setContentOffset:CGPointMake(pageIndex*_pageScorllView.frame.size.width, 0) animated:NO];
}

- (void)dimiss{
    if (_selectBlock) {
        _selectBlock(NO, 0, nil, nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark private method
- (void)p_scrollToSelectRegion{
    
    [self scrollToPageIndex:_resultModel.selectCalenderType];
    
    YKCalenderModel *beginCalender = _resultModel.startCalender;
    YKCalenderModel *endCalender = _resultModel.endCalender;
    YKCalenderType  calenderType = _resultModel.selectCalenderType;
    
    for (id<YKCalenderScrollProtocol> protocolObj in _pageViewList) {
      	if ([protocolObj respondsToSelector:@selector(scrollToBeginCalender:endCalender:calenderType:)]){
            [protocolObj scrollToBeginCalender:beginCalender endCalender:endCalender calenderType:calenderType];
        }
    }
}

@end

