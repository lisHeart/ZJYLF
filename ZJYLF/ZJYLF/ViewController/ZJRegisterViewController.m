//
//  ZJRegisterViewController.m
//  ZJYLF
//  注册
//  Created by 刘高洋 on 2018/6/21.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJRegisterViewController.h"
#import "NetWorkForUserRegister.h"
#import "CountDownTimeButton.h"
#import "RegisterCell.h"
#import "NetWorkForCompanyGetlist.h"

@interface ZJRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,cellTextFieldDelegete>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
//企业数组
@property (nonatomic, strong) NSArray *companyArr;
@property (nonatomic, strong) UserRegisterPostmodel *postMOdel;
@property (nonatomic, strong) CountDownTimeButton *verifyButton;

@end

@implementation ZJRegisterViewController
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"注册";
    
    self.dataArr = [NSMutableArray array];
    
    self.postMOdel  = [[UserRegisterPostmodel alloc] init];
    
    _postMOdel.creatorid = @"ios";
    
    
    NSArray *titArr = @[@"姓名",@"手机号",@"密码",@"职业",@"选择企业"];
    [self getCompanyInfo];
    for (NSString *str in titArr) {
        RegisterModel *model = [[RegisterModel alloc] init];
        model.name = str;
        model.imageName = str;
        [_dataArr addObject:model];
    }
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 50 , SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight-50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    UIButton *sureBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBUtton addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBUtton setTitle:@"注册" forState:UIControlStateNormal];
    [sureBUtton setTitleColor:WhiteBackColor forState:UIControlStateNormal];
    sureBUtton.backgroundColor = TEXTCOLOR(@"487DE5");
    sureBUtton.titleLabel.font = FontOfSize(FontHugeSize);
    sureBUtton.frame = CGRectMake((SCREEN_WIDTH-240)/2, 330 + kNavBarHeight + 100, 240, 40);
    [self.view addSubview:sureBUtton];
    
    
}
//获取企业列表
- (void)getCompanyInfo {
    NetWorkForCompanyGetlist *netWork = [[NetWorkForCompanyGetlist alloc] init];
    [netWork startGetWithBlock:^(CompanyGetlistRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            self.companyArr  = result.data.pagedata;
        }
    }];
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
    RegisterModel *model = _dataArr[indexPath.row];
    
    RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[RegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.cellDelegate = self;
    if (indexPath.row == 4) {
        cell.titLabel.text = model.name;
        cell.input.enabled = NO;
        cell.input.textAlignment = NSTextAlignmentRight;

        //选择企业箭头
        UIImageView *aronView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-31, 19.5, 16, 16)];
        aronView.image = Image(@"去选择企业");
        [cell.contentView addSubview:aronView];
        
    }else if(indexPath.row == 1){
        
        cell.input.keyboardType = UIKeyboardTypeNumberPad;
        cell.titLabel.text = [NSString stringWithFormat:@"%@:",model.name];
    }else if(indexPath.row == 2){
        cell.input.secureTextEntry = YES;
        cell.titLabel.text = [NSString stringWithFormat:@"%@:",model.name];
    }else{
        cell.titLabel.text = [NSString stringWithFormat:@"%@:",model.name];
    }
//    if (indexPath.row == 2) {
//        //获取验证码按钮
//        _verifyButton=[[CountDownTimeButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-105, 17, 90, 20) WithBtnTitle:@"获取验证码"];
//        _verifyButton.titleLabel.font=FontOfSize(FontAlertSize);
//        [_verifyButton addTarget:self action:@selector(getTestInfo) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:_verifyButton];
//    }
    cell.imageView.image = Image(model.imageName);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        RegisterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIAlertController *alert    = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self) weakSelf = self;
        for (CompanyGetlistPagedata *model in self.companyArr ) {
           UIAlertAction *action =  [UIAlertAction actionWithTitle:model.companyname style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                cell.input.text = model.companyname;
               
               _postMOdel.companyid = numberBecomeStrng(model.companyid);
//                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            
            [alert addAction:action];
          
        }
        
     
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void) registerClick {
    if (isBlankString(_postMOdel.name)) {
        ShowMessage(@"姓名不能为空", nil);
        return;
    }
    if (isBlankString(_postMOdel.phone)) {
        ShowMessage(@"手机号不能为空", nil);
        return;
    }
    if (!isMobileNumber(_postMOdel.phone)) {
        ShowMessage(@"手机号不合乎规范", nil);
        return;
    }
    if (isBlankString(_postMOdel.password)) {
        ShowMessage(@"密码不能为空", nil);
        return;
    }
    if (isBlankString(_postMOdel.occupation)) {
        ShowMessage(@"职业不能为空", nil);
        return;
    }
    if (isBlankString(_postMOdel.companyid)) {
        ShowMessage(@"企业不能为空", nil);
        return;
    }
    NetWorkForUserRegister *net = [[NetWorkForUserRegister alloc] init];
    net.postModel = _postMOdel;
    [net startPostWithBlock:^(UserRegisterRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            ShowMessage(@"注册成功", nil);
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            ShowMessage(result.msg, nil);
        }
    }];
}

- (void)getTextFieldDoneContent:(NSString *)str andCell:(id)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
            _postMOdel.name = str;
            break;
        case 1:
            _postMOdel.phone = str;
            break;
        case 2:
            _postMOdel.password = str;
            break;
        case 3:
            _postMOdel.occupation = str;
            break;
            
        default:
            break;
    }
}

- (void)backToUpper {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)getTestInfo {
//
//}
@end
