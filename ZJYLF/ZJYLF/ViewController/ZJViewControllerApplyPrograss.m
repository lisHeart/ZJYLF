//
//  ZJViewControllerApplyPrograss.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/4.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJViewControllerApplyPrograss.h"
#import "NetWorkForProgressApplySearch.h"
#import "ArrowView.h"
#import "ProgressCell.h"

@interface ZJViewControllerApplyPrograss ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSNumber *progress;
@end

@implementation ZJViewControllerApplyPrograss


- (void)viewWillAppear:(BOOL)animated {
     self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"查看申请进度";
    self.TopNavigationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNavBarHeight+147-64);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, self.TopNavigationView.bottom - 27, SCREEN_WIDTH-30, 54)];
    textField.leftView = [[UIImageView alloc]initWithImage:Image(@"搜索")];
    textField.tag =101;
    textField.backgroundColor = WhiteBackColor;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.borderColor = MainBackColor.CGColor;
    textField.layer.borderWidth = 1;
    textField.placeholder = @"输入注册手机号";
    textField.layer.cornerRadius = 6;
    [self.view addSubview:textField];
    
    
    NSArray *titArr = @[@"已申请",@"办理查名",@"网上核名",@"工业园区审批",@"沁园受理材料",@"已出营业执照"];
    _dataArr = [NSMutableArray arrayWithArray:titArr];
    


    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:Image(@"查询") forState:UIControlStateNormal];
    searchButton.frame = CGRectMake(SCREEN_WIDTH - 15 - 66, self.TopNavigationView.bottom-27, 66, 54);
    [searchButton addTarget:self action:@selector(searchBarSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:searchButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchButton.bottom + 10  , SCREEN_HEIGHT, SCREEN_HEIGHT - searchButton.bottom-10)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    UITextField *textField = [self.view viewWithTag:101];
    
    NetWorkForProgressApplySearch *net = [[NetWorkForProgressApplySearch alloc] init];
    net.mobile = textField.text;
    
    [net startGetWithBlock:^(ProgressApplySearchRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            _progress = result.data;
            [_tableView reloadData];
        }
    }];
    
}

#pragma mark - tableView delegata  and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_progress) {
        return _dataArr.count;
    }else {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"register";
    
    ProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[ProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.title = _dataArr[indexPath.row];
    cell.numLab.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
    if (indexPath.row <= [_progress integerValue]) {
        cell.numLab.backgroundColor = TEXTCOLOR(@"497EE5");
        cell.linview.backgroundColor = TEXTCOLOR(@"497EE5");
        cell.lineView1.backgroundColor = TEXTCOLOR(@"497EE5");
        cell.backImage.image = Image(@"已完成状态");
    }else {
        if (indexPath.row == [_progress integerValue] +1) {
            cell.linview.backgroundColor = TEXTCOLOR(@"497EE5");
        }else {
             cell.linview.backgroundColor = TEXTCOLOR(@"9B9B9B");
        }
        cell.numLab.backgroundColor = TEXTCOLOR(@"9B9B9B");
       
        cell.lineView1.backgroundColor = TEXTCOLOR(@"9B9B9B");
        cell.backImage.image = Image(@"未完成状态");

    }
    
    if (indexPath.row == 0) {
        cell.lineView1.hidden = NO;
        cell.linview.hidden = YES;
    }else if (indexPath.row == _dataArr.count -1){
        cell.lineView1.hidden = YES;
        cell.linview.hidden = NO;
    }else {
        cell.lineView1.hidden = NO;
        cell.linview.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
