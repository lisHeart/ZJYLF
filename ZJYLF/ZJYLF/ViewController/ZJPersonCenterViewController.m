//
//  ZJPersonCenterViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/13.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJPersonCenterViewController.h"
#import "HomeViewController.h"
#import "PictureView.h"
#import "ZJFixPasswordViewController.h"
#import "RegisterCell.h"
#import "ZJTaskViewController.h"
#import "ZJHeadViewController.h"
#import "NetWorkForAppUpgradeInfo.h"

@interface ZJPersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ZJPersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = WhiteBackColor;
    //标题
    UILabel * titleLab                                =   [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)*.5, kNavBarHeight - 44 + 12, 250, 20)];
    titleLab.text                           =   @"个人中心";
    titleLab.textColor                      =   DeepBlackTextColor;
    [titleLab setFont:BoldFontOfSize(FontLargeSize)];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLab];
    
    
    
    
   
    
//    PictureView *headView = [[PictureView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-64)/2, kNavBarHeight + 20, 64, 64)];
//    [self.view addSubview:headView];
//
//    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, headView.bottom + 12, 150, 20)];
//    nameLabel.text = [WJGlobalSingleton sharedInstance].username;
//    nameLabel.textColor = DeepBlackTextColor;
//    nameLabel.font = FontOfSize(FontAlertSize);
//    nameLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:nameLabel];
    
    [UIView viewLinePoint:CGPointMake(0,  kNavBarHeight) inView:self.view length:SCREEN_WIDTH andAngle:0 lineColor:ViewBackGroundColor lineWidth:8];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,8+ kNavBarHeight , SCREEN_HEIGHT, SCREEN_HEIGHT - kNavBarHeight-143)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    UIButton *quiteBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [quiteBUtton addTarget:self action:@selector(quiteClick) forControlEvents:UIControlEventTouchUpInside];
    [quiteBUtton setTitle:@"退出登录" forState:UIControlStateNormal];
    [quiteBUtton setTitleColor:WhiteBackColor forState:UIControlStateNormal];
    quiteBUtton.backgroundColor = TEXTCOLOR(@"487DE5");
    quiteBUtton.titleLabel.font = FontOfSize(FontHugeSize);
    quiteBUtton.frame = CGRectMake((SCREEN_WIDTH-240)/2, 358 + kNavBarHeight , 240, 40);
    [self.view addSubview:quiteBUtton];
    
    NSArray *titArr = @[@"修改密码",@"任务追踪",@"投诉",@"建议",@"检查更新"];
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
    cell.input.userInteractionEnabled = NO;
    cell.headView.hidden = YES;
    cell.titLabel.frame = CGRectMake(15, 17, 96, 20);
    
    
    
    //箭头
    UIImageView *aronView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-31, 19.5, 16, 16)];
    aronView.image = Image(@"去选择企业");
    [cell.contentView addSubview:aronView];
    cell.titLabel.text = _dataArr[indexPath.row];
    if (indexPath.row == 4) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.input.text =[NSString stringWithFormat:@"版本v%@",app_Version];
        
        cell.input.textAlignment = NSTextAlignmentRight;
        cell.input.hidden = NO;
    }else {
        cell.input.hidden = YES;
    }
    
//    if (indexPath.row == 2) {
//
//
//
//    }else {
//
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZJFixPasswordViewController *vc =[[ZJFixPasswordViewController alloc] init];
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        ZJHeadViewController *vc =[[ZJHeadViewController alloc] init];
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        ZJTaskViewController *vc= [[ZJTaskViewController alloc] init];
        vc.topTitle  = @"投诉";
    [self.parentVC.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3) {
    ZJTaskViewController *vc= [[ZJTaskViewController alloc] init];
    vc.topTitle  = @"建议";
    [self.parentVC.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4) {
        NetWorkForAppUpgradeInfo *net = [[NetWorkForAppUpgradeInfo alloc] init];
        net.appname = @"yunlifang";
        net.platform = @"ios";
        [net startGetWithBlock:^(AppUpgradeInRespone * result, NSError *error) {
            if ([result.code isEqualToString:@"200"]) {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                if ([result.data.verno isEqualToString:app_Version]) {
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"已是最新版本" preferredStyle:UIAlertControllerStyleAlert];//UIAlertControllerStyleAlert视图在中央
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }else {
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新的版本点击前往" preferredStyle:UIAlertControllerStyleAlert];//UIAlertControllerStyleAlert视图在中央
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *str =result.data.download;
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    }];//https在iTunes中找，这里的事件是前往手机端App store下载微信
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            
            }
        }];
    }
}
//退出
- (void)quiteClick {
    [WJGlobalSingleton sharedInstance].hasLogin = NO;
    [WJGlobalSingleton sharedInstance].username = @"";
    [WJGlobalSingleton sharedInstance].mobile = @"";
    [WJGlobalSingleton sharedInstance].password = @"";
    [WJGlobalSingleton sharedInstance].companyid = @"";
//    HomeViewController *rootViewController = (HomeViewController*)[AppDelegate appDelegate].window.rootViewController;
    [self.parentVC goToLoginViewController];
}

@end
