//
//  ZJLoginViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/13.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJLoginViewController.h"
#import "NetWorkForUserRegister.h"
#import "HomeViewController.h"
#import "ZJRegisterViewController.h"
#import "RegisterCell.h"
#import "AppDelegate.h"

@interface ZJLoginViewController ()<UITableViewDelegate,UITableViewDataSource,cellTextFieldDelegete>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
//企业数组
@property (nonatomic, strong) UseroginPostmodel *postMOdel;
@end

@implementation ZJLoginViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isComeFromApply) {
        self.tabBarController.tabBar.hidden = YES;
    }else {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.TopNavigationView.hidden = YES;
    
    _postMOdel = [[UseroginPostmodel alloc] init];
    self.view.backgroundColor = WhiteBackColor;
    //标题
    UILabel * titleLab                                =   [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)*.5, kNavBarHeight - 44 + 12, 250, 20)];
    titleLab.text                           =   @"登录";
    titleLab.textColor                      =   DeepBlackTextColor;
    [titleLab setFont:BoldFontOfSize(FontLargeSize)];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLab];
    
    //返回按钮
    UIButton *back                    =   [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame                        =   CGRectMake(5, kNavBarHeight - 44 + 2, 40 , 40);
    back.tag = 44;
    back.imageEdgeInsets              =   UIEdgeInsetsMake(5, 5, 5, 5);
    [back setImage:Image(@"返回") forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToUpper) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    if (self.isComeFromApply) {
        back.hidden = NO;
    }else{
        back.hidden = YES;
    }
    
    NSArray *titArr = @[@"手机号",@"密码"];
    _dataArr  = [NSMutableArray arrayWithArray:titArr];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 50 , SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight-50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.scrollEnabled = NO;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton addTarget:self action:@selector(loginIn) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:WhiteBackColor forState:UIControlStateNormal];
    loginButton.backgroundColor = TEXTCOLOR(@"487DE5");
    loginButton.titleLabel.font = FontOfSize(FontHugeSize);
    loginButton.frame = CGRectMake((SCREEN_WIDTH-240)/2, 110 + kNavBarHeight + 100, 240, 40);
    [self.view addSubview:loginButton];
    
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:WhiteBackColor forState:UIControlStateNormal];
    registerButton.backgroundColor = TEXTCOLOR(@"487DE5");
    registerButton.titleLabel.font = FontOfSize(FontHugeSize);
    registerButton.frame = CGRectMake((SCREEN_WIDTH-240)/2, 180 + kNavBarHeight + 100, 240, 40);
    [self.view addSubview:registerButton];
    
    
    
}


#pragma mark - tableView delegata  and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"regist";
    NSString *name = _dataArr[indexPath.row];
    
    RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[RegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.cellDelegate = self;

    cell.titLabel.text = name;
    cell.imageView.image = Image(name);
    if (indexPath.row == 1) {
        cell.input.secureTextEntry = YES;
    }else{
        cell.input.keyboardType = UIKeyboardTypeNumberPad;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)getTextFieldDoneContent:(NSString *)str andCell:(id)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
            _postMOdel.mobile = str;
            break;
        case 1:
            _postMOdel.password = str;
            break;
            
        default:
            break;
    }
}

//登录
- (void)loginIn {
    
    [self.view endEditing:YES];
    if (isBlankString(_postMOdel.mobile)) {
        ShowMessage(@"手机号不能为空", nil);
        return;
    }
    if (!isMobileNumber(_postMOdel.mobile)) {
        ShowMessage(@"手机号不合乎规范", nil);
        return;
    }
    if (isBlankString(_postMOdel.password)) {
        ShowMessage(@"密码不能为空", nil);
        return;
    }
    
    NetWorkForUserogin *net = [[NetWorkForUserogin alloc] init];
    net.postModel = _postMOdel;
    [self startWithCursor];
    [net startPostWithBlock:^(UseroginRespone * result, NSError *error) {
        [self stopWatiCursor];
        if ([result.code isEqualToString:@"200"]) {
            
            
            [WJGlobalSingleton sharedInstance].hasLogin = YES;
            [WJGlobalSingleton sharedInstance].username = result.data.username;
            [WJGlobalSingleton sharedInstance].mobile = result.data.mobile;
            [WJGlobalSingleton sharedInstance].password = _postMOdel.password;
            [WJGlobalSingleton sharedInstance].companyid = result.data.companyid;
            [WJGlobalSingleton sharedInstance].userid = result.data.userid;
            
            if (self.isComeFromApply) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                HomeViewController *rootViewController = (HomeViewController*)[AppDelegate appDelegate].window.rootViewController;
                [self.parentVC goToTableBarViewCOntroller];
            }
           
            
        }else {
            ShowMessage(@"登录失败", nil);
        }
    }];
    
}

//注册
- (void) registerClick{
    ZJRegisterViewController *vc = [[ZJRegisterViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void) backToUpper{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
