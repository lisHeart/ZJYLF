//
//  ZJFixPasswordViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJFixPasswordViewController.h"
#import "RegisterCell.h"
#import "NetWorkForModifyPassword.h"

@interface ZJFixPasswordViewController ()<UITableViewDelegate,UITableViewDataSource,cellTextFieldDelegete>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ModifyPasswordPostmodel *model;
@property (nonatomic, copy) NSString *verfiPa;
@end

@implementation ZJFixPasswordViewController
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"修改密码";
    
    _model = [[ModifyPasswordPostmodel alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + kNavBarHeight  , SCREEN_HEIGHT, SCREEN_HEIGHT - kNavBarHeight-143)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [surebutton addTarget:self action:@selector(quiteClick) forControlEvents:UIControlEventTouchUpInside];
    [surebutton setTitle:@"确认修改" forState:UIControlStateNormal];
    [surebutton setTitleColor:WhiteBackColor forState:UIControlStateNormal];
    surebutton.backgroundColor = TEXTCOLOR(@"487DE5");
    surebutton.titleLabel.font = FontOfSize(FontHugeSize);
    surebutton.frame = CGRectMake((SCREEN_WIDTH-240)/2, 358 + kNavBarHeight , 240, 40);
    [self.view addSubview:surebutton];
    
    NSArray *titArr = @[@"旧密码",@"新密码",@"新密码"];
    _dataArr = [NSMutableArray arrayWithArray:titArr];
}

#pragma mark - tableView delegata  and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"register";
    
    RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[RegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.headView.hidden = YES;
    cell.titLabel.frame = CGRectMake(15, 17, 96, 20);
    cell.cellDelegate = self;
    cell.input.secureTextEntry = YES;
    
    cell.titLabel.text = _dataArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)getTextFieldDoneContent:(NSString *)str andCell:(id)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath.row == 0) {
        _model.oldpassword = str;
        
    }else if (indexPath.row == 2){
        _model.newpassword = str;
    }else {
        _verfiPa =str;
    }
}

- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)quiteClick {
    if (![_model.oldpassword isEqualToString:[WJGlobalSingleton sharedInstance].password]) {
        NSLog(@"%@",[WJGlobalSingleton sharedInstance].password);
        ShowMessage(@"输入的旧密码错误", nil);
        return;
    }
    if (![_model.newpassword isEqualToString:_verfiPa]) {
        ShowMessage(@"两次输入密码不一致", nil);
        return;
    }
    
    NetWorkForModifyPassword *net = [[NetWorkForModifyPassword alloc] init];
    _model.userid = [WJGlobalSingleton sharedInstance].userid;
    _model.mobile = [WJGlobalSingleton sharedInstance].mobile;
    _model.verifycode = @"";
    _model.usertype = @"1";
    net.postModel = _model;
    
    [net startPostWithBlock:^(ModifyPasswordRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            ShowMessage(@"修改成功", nil);
            [WJGlobalSingleton sharedInstance].password = _model.newpassword;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
@end
