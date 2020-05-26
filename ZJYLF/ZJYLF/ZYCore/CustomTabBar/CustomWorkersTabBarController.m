//
//  CustomTabBarController.m
//  CustomTabBarController
//
//  Created by angie on 22/05/2012.
//  Copyright (c) 2012 cetetek. All rights reserved.
//

// 标准系统状态栏高度
#define SYS_STATUSBAR_HEIGHT                        20
// 热点栏高度
#define HOTSPOT_STATUSBAR_HEIGHT                    20

#import "CustomWorkersTabBarController.h"
#import "CustomWorkersTabBar.h"

@interface CustomWorkersTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
@end

@implementation CustomWorkersTabBarController
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize changeIndexDelegate = _changeIndexDelegate;

- (id)initWithViewControllers:(NSArray *)controllers imageArray:(NSArray *)images  titleArray:(NSArray*)titleArray{
	self = [super init];
	if (self != nil){
		_viewControllers = [NSMutableArray arrayWithArray:controllers];
        _containerView = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication].delegate window].frame];
		_transitionView = [[UIView alloc] init];
        
        _tabBar = [[CustomWorkersTabBar alloc] initWithButtonImages:images titleArray:titleArray];
		_tabBar.delegate = self;
	}
	return self;
}

- (CGFloat)getTabbarTop {
    CGFloat top = SCREEN_HEIGHT - kTabBarHeight;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
        top =  top - WCStatusBarHeight;
    }
    return top;
}

- (void)loadView {
	[super loadView];
    
    _transitionView.frame =CGRectMake(0, 0, SCREEN_WIDTH, self.view.height);
    self.tabBar.frame = CGRectMake(0, [self getTabbarTop], kWCScreenSize.width, kTabBarHeight);

	[_containerView addSubview:_transitionView];
	[_containerView addSubview:_tabBar];
	self.view = _containerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UIApplication sharedApplication].statusBarFrame.size.height == 40.0f)
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    else
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUIApplicationWillChangeStatusBarFrameNotification:)
                                                 name:UIApplicationWillChangeStatusBarFrameNotification
                                               object:nil];
}

- (void)handleUIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification {
    
    CGRect newStatusBarFrame = [(NSValue *)[notification.userInfo objectForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    
    BOOL bPersonalHotspotConnected = (CGRectGetHeight(newStatusBarFrame) == (SYS_STATUSBAR_HEIGHT+HOTSPOT_STATUSBAR_HEIGHT)?YES:NO);
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    CGRect frame = self.tabBar.frame;
    if (bPersonalHotspotConnected) {
        frame.origin.y -= 20;
        self.tabBar.frame = frame;
    }
    else {
        frame.origin.y += 20;
        self.tabBar.frame = frame;
    }
    
}

- (void)viewDidUnload{
	[super viewDidUnload];
	
	_tabBar = nil;
	_viewControllers = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

#pragma mark - instant methods

- (CustomWorkersTabBar *)tabBar{
	return _tabBar;
}

- (NSUInteger)selectedIndex{
	return _selectedIndex;
}
- (UIViewController *)selectedViewController{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index{
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}

#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index {
    UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
    selectedVC.view.alpha = 1.0f;
  
    UINavigationController *nvc = (UINavigationController *)selectedVC;
    [nvc popToRootViewControllerAnimated:NO];
    
    
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0){
        return;
    }
    
    if (index == 1) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    _selectedIndex = index;
	selectedVC.view.frame = _transitionView.frame;
    selectedView.alpha = 0.0;
    if ([selectedVC.view isDescendantOfView:_transitionView]) {//isDescendantOfView:(UIView *)view方法，判断view是不是指定视图的子视图
		[_transitionView bringSubviewToFront:selectedVC.view];
	}
	else {
		[_transitionView addSubview:selectedVC.view];
	}
    
    if (selectedView)
        [selectedView removeFromSuperview];
    selectedView = selectedVC.view;    
}

- (void)hiddentabBar:(BOOL)hidden isAnimat:(BOOL)isAnimat{
    if(isAnimat){
        if(hidden && self.tabBar.frame.origin.y == self.view.height - kTabBarHeight){       //隐藏tabbar
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            self.tabBar.frame = CGRectMake(0, self.view.height, SCREEN_WIDTH, kTabBarHeight);
            [UIView commitAnimations];
            
        } else if(!hidden && self.tabBar.frame.origin.y == self.view.height){                 //显示tabbar
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            self.tabBar.frame = CGRectMake(0, self.view.height - kTabBarHeight, SCREEN_WIDTH, kTabBarHeight);
            [UIView commitAnimations];
        }
    }
    else{
        if(hidden && self.tabBar.frame.origin.y == self.view.height - kTabBarHeight){       //隐藏tabbar
            self.tabBar.frame = CGRectMake(0, self.view.height, SCREEN_WIDTH, kTabBarHeight);
            
        } else if(!hidden && self.tabBar.frame.origin.y == self.view.height){                 //显示tabbar
            self.tabBar.frame = CGRectMake(0, self.view.height - kTabBarHeight, SCREEN_WIDTH, kTabBarHeight);
        }
    }
}

#pragma mark tabBar delegates
- (void)tabBar:(CustomWorkersTabBar *)tabBar didSelectIndex:(NSInteger)index{
	[self displayViewAtIndex:index];

    if ([_changeIndexDelegate respondsToSelector:@selector(customTabBar:didSelectIndex:)]){
        [_changeIndexDelegate customTabBar:self didSelectIndex:index];
    }

}

#pragma mark - 为tabbar添加小红点
- (void)showBadgeOnItemIndex:(int)index{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.tabBar.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / 3;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self.tabBar addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(int)index{
    
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.tabBar.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}


@end
