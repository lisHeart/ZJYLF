//
//  ZJHomeTableViewController.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/13.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJTaskPursueViewController.h"
#import "ZJHeadViewController.h"
#import "ZJPersonCenterViewController.h"
#import "CustomWorkersTabBarController.h"
#import "ZJLoginViewController.h"

@interface ZJHomeTableViewController : UIViewController<ChangeIndexDelegate>

@property (nonatomic, strong) CustomWorkersTabBarController *customTabBarController;
@end
