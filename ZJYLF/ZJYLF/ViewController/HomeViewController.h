//
//  HomeViewController.h
//  test
//
//  Created by hymac on 2017/5/9.
//  Copyright © 2017年 hymac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJHomeTableViewController.h"
#import "ZJLoginViewController.h"
//#import "ZJPersonCenterViewController.h"

@class ZJPersonCenterViewController;
@interface HomeViewController : UIViewController
@property (nonatomic, strong)ZJPersonCenterViewController *zJHomeTableViewController;


-(void)goToTableBarViewCOntroller;
-(void)goToLoginViewController;
@end
