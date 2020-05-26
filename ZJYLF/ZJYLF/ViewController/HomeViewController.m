//
//  HomeViewController.m
//  test
//  要么登录页 要么 首页
//  Created by hymac on 2017/5/9.
//  Copyright © 2017年 hymac. All rights reserved.
//

#import "HomeViewController.h"



@interface HomeViewController ()

@property (nonatomic, strong) ZJLoginViewController *loginViewController;

@end

@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    if([WJGlobalSingleton sharedInstance].hasLogin){ //已经登陆成功不需要再登陆
        
 
        [self.view addSubview:self.zJHomeTableViewController.view];
        
    }
    else{//没有登陆，需要登陆
        [self addChildViewController:self.loginViewController];
        [self.view addSubview:self.loginViewController.view];
    }

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if([WJGlobalSingleton sharedInstance].hasLogin){ //已经登陆成功不需要再登陆
//
        self.zJHomeTableViewController = [[ZJPersonCenterViewController alloc]init];
        self.zJHomeTableViewController.parentVC = self;
//        [self.view addSubview:self.zJHomeTableViewController.view];
    
//    }
//    else{//没有登陆，需要登陆
//
        self.loginViewController = [[ZJLoginViewController alloc] init];
        self.loginViewController.parentVC = self;
//
//        [self.view addSubview:self.loginViewController.view];
//    }
}


-(void)goToTableBarViewCOntroller{
    NSLog(@"goToTableBarViewCOntroller ........... ");
    [self.zJHomeTableViewController removeFromParentViewController];
    self.zJHomeTableViewController = [[ZJPersonCenterViewController alloc]init];
    [self addChildViewController:self.zJHomeTableViewController];
    self.zJHomeTableViewController.parentVC = self;
    [self transitionFromViewController:self.loginViewController toViewController:self.zJHomeTableViewController duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        // do nothing
    } completion:^(BOOL finished) {
        //do nothing
    }];
    
    
}

-(void)goToLoginViewController{
    NSLog(@"goToLogonViewController ........... ");
    
    [self.loginViewController removeFromParentViewController];
    
    self.loginViewController = [[ZJLoginViewController alloc] init];
     self.loginViewController.parentVC = self;
    [self addChildViewController:self.loginViewController];
    if(self.childViewControllers.count == 1) {
        [self addChildViewController:self.zJHomeTableViewController];
    }
    
    [self transitionFromViewController:self.zJHomeTableViewController toViewController:self.loginViewController duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        // do nothing
    } completion:^(BOOL finished) {
        //do nothing
    }];
    
}


@end
