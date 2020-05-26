//
//  ZJBaseViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/13.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJBaseViewController.h"
#import "MBProgressHUD.h"

@interface ZJBaseViewController ()
@property (nonatomic, strong) MBProgressHUD *progressview;
@end

@implementation ZJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteBackColor;
    [self initNavigation];
}

#pragma mark - 自定义标题
- (void)initNavigation
{
    
    //总背景
    self.TopNavigationView                  =   [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavBarHeight)];
    //    self.TopNavigationView.backgroundColor  =   TEXTCOLOR(@"ffffff");
    self.TopNavigationView.backgroundColor  =   MainBackColor;
    
    //返回按钮
    UIButton *backButton                    =   [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame                        =   CGRectMake(5, kNavBarHeight - 44 + 2, 40 , 40);
    backButton.tag = 44;
    backButton.imageEdgeInsets              =   UIEdgeInsetsMake(5, 5, 5, 5);
    [backButton setImage:BackImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToUpper) forControlEvents:UIControlEventTouchUpInside];
    [self.TopNavigationView addSubview:backButton];
    
    //标题
    self.titleLab                                =   [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)*.5, kNavBarHeight - 44 + 12, 250, 20)];
    self.titleLab.text                           =   self.title;
    self.titleLab.textColor                      =   WhiteBackColor;
    [self.titleLab setFont:BoldFontOfSize(FontLargeSize)];
    [self.titleLab setTextAlignment:NSTextAlignmentCenter];
    [self.TopNavigationView addSubview:self.titleLab];
    
    [self.view addSubview:self.TopNavigationView];
    
//    //底部分割线
//    [UIView viewLinePoint:CGPointMake(0, kNavBarHeight)
//                   inView:self.TopNavigationView
//                   length:SCREEN_WIDTH
//                 andAngle:0
//                lineColor:BACKCOLOR(@"dddddd")
//                lineWidth:1.0];
}

- (void) backToUpper {
    
}

- (void)startWithCursor
{
    if (self.progressview == nil) {
        self.progressview = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    } else {
        [self.progressview show:YES];
    }
}

- (void)stopWatiCursor
{
    if (self.progressview) {
        [self.progressview hide:NO];
    }
}

@end
