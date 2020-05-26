//
//  ZJBaseViewController.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/13.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCServiceBase_Test.h"

@interface ZJBaseViewController : UIViewController<WCServiceTestDelegate>
/*****************自定义标题样式**********************/
@property (nonatomic, strong)UIView         *TopNavigationView;     //顶部仿照UINavigation的标题头的view
@property (nonatomic, strong)UILabel        *titleLab;     //标题
/*****************自定义标题样式**********************/
@end
