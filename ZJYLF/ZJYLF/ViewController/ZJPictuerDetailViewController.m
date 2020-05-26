//
//  ZJPictuerDetailViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJPictuerDetailViewController.h"

@interface ZJPictuerDetailViewController ()

@end

@implementation ZJPictuerDetailViewController
- (void)viewWillAppear:(BOOL)animated {
     self.tabBarController.tabBar.hidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"详情";
    
    
}


- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
