//
//  ZJArticleDetailViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/26.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJArticleDetailViewController.h"
#import <WebKit/WebKit.h>
@interface ZJArticleDetailViewController ()<WKNavigationDelegate,WKUIDelegate>

@end

@implementation ZJArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
   
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, kNavBarHeight+13, SCREEN_WIDTH-15, 20)];
    title.text = _model.articletitle;
    title.textColor = ContentTextColor;
    title.font = BoldFontOfSize(FontAlertSize);
    [self.view addSubview:title];

    [UIView viewLinePoint:CGPointMake(15, kNavBarHeight+ 45) inView:self.view length:SCREEN_WIDTH-30 andAngle:0 lineColor:SepartorLineColor lineWidth:1];

    UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(14, kNavBarHeight +60, 40, 20)];
    if ([_model.typeid isEqual:@0]) {
         self.titleLab.text = @"公告详情";
        type.text = @"公告";
    }else if ([_model.typeid isEqual:@1]) {
         self.titleLab.text = @"互动详情";
        type.text = @"互动";
    }else if ([_model.typeid isEqual:@2]) {
         self.titleLab.text = @"政策详情";
        type.text = @"政策";
    }else if ([_model.typeid isEqual:@5]) {
        self.titleLab.text = @"招聘详情";
    }else if ([_model.typeid isEqual:@3]) {
        self.titleLab.text = @"企业详情";
    }else {
        self.titleLab.text = @"详情";
    }
    type.layer.borderColor = TEXTCOLOR(@"979797").CGColor;
    type.layer.borderWidth = 1;
    type.layer.cornerRadius = 10;
    type.textAlignment = NSTextAlignmentCenter;
    type.font = FontOfSize(FontNormalSize);
    type.textColor = GrayTextColor;
    [self.view addSubview:type];
    
   
    

    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(type.right + 20, kNavBarHeight +60, SCREEN_WIDTH - type.right -20, 20)];
    time.font = FontOfSize(FontNormalSize);
    time.text = _model.createtime;
    time.textColor = GrayTextColor;
    [self.view addSubview:time];
    if (isBlankString(type.text)) {
        type.hidden = YES;
        time.frame = CGRectMake(14,  kNavBarHeight +60, SCREEN_WIDTH - type.right -20, 20);
        
    }
//
//
//
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, time.bottom + 20, SCREEN_WIDTH - 30, SCREEN_HEIGHT- time.bottom -20)];
//    textView.text = _model.articlecontent;
//    textView.font = FontOfSize(FontNormalSize);
//    textView.textColor = ContentTextColor;
//    textView.editable = NO;
//    [self.view addSubview:textView];
//
//
//    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
    wkWebConfig.userContentController = wkUController;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, time.bottom + 20, SCREEN_WIDTH, SCREEN_HEIGHT- time.bottom -20) configuration:wkWebConfig];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
   
    [webView loadHTMLString:_model.articlecontent baseURL:nil];
 }
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self startWithCursor];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
     [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'" completionHandler:nil];
    [self stopWatiCursor];

  
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
