//
//  ZJApplyViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/11/9.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJApplyViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "ZJLoginViewController.h"
#import "JSObject.h"

@interface ZJApplyViewController ()<WKUIDelegate,JSExport,WKScriptMessageHandler,WKNavigationDelegate>
@property (nonatomic, strong)WKWebView *webView;

@end

@implementation ZJApplyViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSString * paramString = [WJGlobalSingleton sharedInstance].companyid;
//    //transferPrama()是JS的语言
//    NSString * jsStr = [NSString stringWithFormat:@"setCompanyId('%@')",paramString];
//    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"result=%@  error=%@",result, error);
//    }];
    self.tabBarController.tabBar.hidden = NO;
    // 添加JS的方法的调用处理
    
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    NSString *JScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:JScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    configuration.userContentController = wkUController;
    
    
    
    //http://www.zjyunlifang.com
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavBarHeight-kTabBarHeight) configuration:configuration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    NSURL *url = [NSURL URLWithString:@"http://www.zjyunlifang.com/company/services"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    [self.view addSubview:_webView];
    
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"goLogin"];
    [self.webView reload];
    
    
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewWillDisappear:(BOOL)animated {

    // 添加JS的方法的调用处理，必须销毁，否则会造成循环引用
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"goLogin"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.TopNavigationView.backgroundColor = WhiteBackColor;
    self.titleLab.textColor = DeepBlackTextColor;
    self.titleLab.text = @"服务申请";

    
   

}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self startWithCursor];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self stopWatiCursor];
    NSString * paramString = [WJGlobalSingleton sharedInstance].companyid;
    //transferPrama()是JS的语言
    NSString * jsStr = [NSString stringWithFormat:@"setCompanyId('%@')",paramString];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"result=%@  error=%@",result, error);
    }];
}
//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self startWithCursor];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopWatiCursor];
    
  
}
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@----%@",message.name,message.body);
    if ([message.name isEqualToString:@"goLogin"]) {
        ZJLoginViewController  *vc= [[ZJLoginViewController alloc] init];
        vc.isComeFromApply = YES;
        [self.navigationController pushViewController:vc animated:YES];
    
    }

    
    // 通过name来做判断 做相应的处理
}



- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
