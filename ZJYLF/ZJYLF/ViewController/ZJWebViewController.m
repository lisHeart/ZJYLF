//
//  ZJWebViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/11/8.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJWebViewController.h"

@interface ZJWebViewController ()<UIWebViewDelegate>

@end

@implementation ZJWebViewController
- (void)viewWillAppear:(BOOL)animated {
     self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = self.titleS;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavBarHeight)];
    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self startWithCursor];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopWatiCursor];
}
- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
