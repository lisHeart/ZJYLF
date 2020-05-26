//
//  ZJHomeTableViewController.m
//  ZJYLF
//  首页的tableController
//  Created by 刘高洋 on 2018/6/13.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJHomeTableViewController.h"
#import "ZJApplyViewController.h"


@interface ZJHomeTableViewController ()


@end

@implementation ZJHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubController];
}

+ (ZJHomeTableViewController *)sharedInstance{
    static ZJHomeTableViewController *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[ZJHomeTableViewController alloc] init];
    });
    return sharedInstance;
}

- (void)initSubController{
    
    UITabBarController * tabbarVC = [[UITabBarController alloc]init];
    //名字
    NSArray *nameArr = [NSArray arrayWithObjects:
                        @"园区咨询",
                        @"服务申请",
                        @"个人中心", nil];
    //园区首页
    ZJApplyViewController *headVC = [[ZJApplyViewController alloc] init];
    UINavigationController *nav_head = [[UINavigationController alloc]initWithRootViewController:headVC];
    nav_head.navigationBarHidden = YES;
    headVC.tabBarItem.image = [UIImage imageNamed:@"园区资讯-未选中"];
    headVC.tabBarItem.selectedImage = [UIImage imageNamed:@"园区资讯-选中"];
    headVC.view.backgroundColor = [UIColor clearColor];
    headVC.tabBarItem.title = @"园区咨询";
    [tabbarVC addChildViewController:headVC];
    
    
    //任务追踪
    ZJTaskPursueViewController *taskVc = [[ZJTaskPursueViewController alloc] init];
    UINavigationController *nav_task = [[UINavigationController alloc] initWithRootViewController:taskVc];
    nav_task.navigationBarHidden = YES;
    taskVc.tabBarItem.image = [UIImage imageNamed:@"服务申请-未选中"];
    taskVc.tabBarItem.selectedImage = [UIImage imageNamed:@"服务申请-未选中"];
    taskVc.view.backgroundColor = [UIColor clearColor];
    taskVc.tabBarItem.title = @"服务申请";
    [tabbarVC addChildViewController:taskVc];
    
    //个人中心
    UINavigationController *nav_person ;
    if ([WJGlobalSingleton sharedInstance].hasLogin) {
        ZJPersonCenterViewController *personVC = [[ZJPersonCenterViewController alloc] init];
        nav_person = [[UINavigationController alloc] initWithRootViewController:personVC];
    }else {
        ZJLoginViewController *personVC = [[ZJLoginViewController alloc] init];
        nav_person = [[UINavigationController alloc] initWithRootViewController:personVC];
    }
    nav_person.tabBarItem.image = [UIImage imageNamed:@"个人中心"];
    nav_person.tabBarItem.selectedImage = [UIImage imageNamed:@"个人中心-选中状态"];
    nav_person.view.backgroundColor = [UIColor clearColor];
    nav_person.tabBarItem.title = @"个人中心";
    [tabbarVC addChildViewController:nav_person];
    nav_person.navigationBarHidden = YES;
    
    NSArray *navArray = [NSArray arrayWithObjects:nav_task,
nav_head, nav_person, nil];
    //加载图片
    NSMutableDictionary * constructionProjectImageDic= [NSMutableDictionary dictionaryWithCapacity:0];
    
    [constructionProjectImageDic setObject:[UIImage imageNamed:@"园区资讯-未选中"] forKey:@"Default"];

    [constructionProjectImageDic setObject:[UIImage imageNamed:@"园区资讯-选中"] forKey:@"Seleted"];
    NSMutableDictionary *taskImageDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [taskImageDic setObject:[UIImage imageNamed:@"服务申请-未选中"] forKey:@"Default"];
    [taskImageDic setObject:[UIImage imageNamed:@"服务申请-未选中"] forKey:@"Seleted"];
    NSMutableDictionary *myImageDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [myImageDic setObject:[UIImage imageNamed:@"个人中心"] forKey:@"Default"];
    [myImageDic setObject:[UIImage imageNamed:@"个人中心-选中状态"] forKey:@"Seleted"];
    NSArray *imageArray = [NSArray arrayWithObjects:constructionProjectImageDic ,taskImageDic,myImageDic, nil];

    self.customTabBarController = [[CustomWorkersTabBarController alloc] initWithViewControllers:navArray
                                                                                      imageArray:imageArray titleArray:nameArr];
    
    
    self.customTabBarController.changeIndexDelegate = self;
    self.customTabBarController.view.backgroundColor = [UIColor clearColor];
    self.customTabBarController.selectedIndex = 0;
    
    
    [self.view addSubview:self.customTabBarController.view];
    
}

@end
