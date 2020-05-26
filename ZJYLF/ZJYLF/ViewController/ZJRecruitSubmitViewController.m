//
//  ZJRecruitSubmitViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJRecruitSubmitViewController.h"
#import "WETextView.h"
#import "NetWorkForRecruitSubmit.h"

@interface ZJRecruitSubmitViewController ()<TextFieldDoneDelegate>
@property (nonatomic, strong) RecruitSubmitPostmodel *model;

@end

@implementation ZJRecruitSubmitViewController
- (void)viewWillAppear:(BOOL)animated {
     self.tabBarController.tabBar.hidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"园区招聘";
    
    _model = [[RecruitSubmitPostmodel alloc] init];
    WETextView *textView= [[WETextView alloc] initWithFrame:CGRectMake(15, self.TopNavigationView.bottom +30 , SCREEN_HEIGHT - 30, 149)];
    textView.placeHolderLabel.text = @"输入招聘信息";
    textView.layer.borderWidth = 0;
    textView.Donedelegate = self;
    textView.backgroundColor = TEXTCOLOR(@"F5F5F5");
    textView.FontNumLabel.hidden = YES;
    textView.Num = 10000;
    [self.view addSubview:textView];
    
    UIButton *sureBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBUtton addTarget:self action:@selector(subClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBUtton setTitle:@"提交" forState:UIControlStateNormal];
    [sureBUtton setTitleColor:WhiteBackColor forState:UIControlStateNormal];
    sureBUtton.backgroundColor = TEXTCOLOR(@"487DE5");
    sureBUtton.titleLabel.font = FontOfSize(FontHugeSize);
    sureBUtton.layer.cornerRadius = 30;
    sureBUtton.layer.borderWidth = 1;
    sureBUtton.layer.borderColor = MainBackColor.CGColor;
    sureBUtton.frame = CGRectMake((SCREEN_WIDTH-156)/2, textView.bottom +80, 156, 42);
    [self.view addSubview:sureBUtton];
    
    
}
- (void) InputDone:(NSString *)textViewText {
    _model.recruitcontent = textViewText;
}

- (void)subClick{
    NetWorkForRecruitSubmit *net = [[NetWorkForRecruitSubmit alloc] init];
    _model.companyid = [WJGlobalSingleton sharedInstance].companyid;
    _model.submitor = [WJGlobalSingleton sharedInstance].userid;
    net.postModel = _model;
    [net startPostWithBlock:^(RecruitSubmitRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            ShowMessage(result.msg, nil);
        }
    }];
}
- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
