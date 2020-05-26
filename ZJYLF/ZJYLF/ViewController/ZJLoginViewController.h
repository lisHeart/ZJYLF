//
//  ZJLoginViewController.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/13.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HomeViewController.h"
@class HomeViewController;
@interface ZJLoginViewController : ZJBaseViewController
@property (nonatomic, assign)BOOL isComeFromApply;
@property (nonatomic, strong)HomeViewController *parentVC;
@end
