//
//  HTTPViewController.m
//  BQReport
//
//  Created by 杨卡 on 2017/9/22.
//  Copyright © 2017年 yangka. All rights reserved.
//

#import "HTTPViewController.h"

@interface HTTPViewController (){
    UITextView *textView;
    
}

@end

@implementation HTTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];

//    textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 50, SelfViewWidth-20, 100)];
//    textView.textColor = [UIColor blackColor];
//    textView.font = [UIFont boldSystemFontOfSize:16];
//    textView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:textView];
//
//    UIButton *button1  =[[UIButton alloc] initWithFrame:CGRectMake(10, textView.maxY+30, SelfViewWidth-20, 40)];
//    [button1 setTitle:@"更换新的地址" forState:UIControlStateNormal];
//    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button1.backgroundColor  =[UIColor blueColor];
//    [button1 addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button1];
//
//    UIButton *button2  =[[UIButton alloc] initWithFrame:CGRectMake(10, textView.maxY+30, SelfViewWidth-20, 40)];
//    [button2 setTitle:@"直使用老地址" forState:UIControlStateNormal];
//    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button2.backgroundColor  =[UIColor blueColor];
//    [button2 addTarget:self action:@selector(gotoMainPage) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button2];
}

- (void)update{
    
}

- (void)gotoMainPage{
    
}

@end
