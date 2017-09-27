# YKCalender

### 仿照猫眼票房日历开发

![组件截图](https://github.com/YangKa/YKCalender/raw/master/snapshot.png)

### 思路
采用Protocol去类型化，runtime机制降低耦合度，使架构灵活易修改。

### Use
引用 #import "YKCalenderController.h"

```object-c

//上一次选择的日期和日期类型
YKResultCalenderModel *result = [YKResultCalenderModel resultCalenderWithStart:_startModel end:_endModel type:_calenderType];
    
    YKCalenderController *VC = [[YKCalenderController alloc] initWithIntervalYears:4 defaultCalender:result selectComplete:^(BOOL selected, YKCalenderType calenderType, YKCalenderModel *startModel, YKCalenderModel *endModel) {
        
        if (selected) {
            //保存历史选择
            _calenderType = calenderType;
            _startModel = startModel;
            _endModel = endModel;
            
            //转换日期格式，可以修改YKCalenderModel中的 `dateTextForCalenderType:`方法
            NSString *startDate = [startModel dateTextForCalenderType:calenderType];
            NSLog(@"startDate=%@", startDate);
            if (calenderType == YKCalenderType_region) {
                NSString *endDate = [endModel dateTextForCalenderType:calenderType];
                NSLog(@"endDate=%@", endDate);
            }
        }
    }];
    [self presentViewController:VC animated:YES completion:nil];
```

### 自定义更多样式
第一步：继承YKCalenderBaseView

第二步：定义自己的布局和逻辑

第三部：将新CalenderView的标题和类名添加到YKCalenderController中

```object-c

//随意添加和修改顺序，自动映射到生成的界面中
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
```
