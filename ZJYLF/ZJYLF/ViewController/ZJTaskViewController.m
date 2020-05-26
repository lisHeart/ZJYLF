//
//  ZJTaskViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/24.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJTaskViewController.h"
#import "NetWorkForTaskSubmit.h"
#import "TaskCell.h"
#import "WETextView.h"

@interface ZJTaskViewController ()<UITableViewDelegate,UITableViewDataSource,cellTextFieldDelegete,TextFieldDoneDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
//企业数组
@property (nonatomic, strong) TaskSubmitPostmodel *postMOdel;

@end

@implementation ZJTaskViewController


- (void)viewWillAppear:(BOOL)animated {
     self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.titleLab.text = self.topTitle;
    
    _postMOdel = [[TaskSubmitPostmodel alloc] init];
    
    _postMOdel.submitor = [WJGlobalSingleton sharedInstance].userid;
    _postMOdel.companyid = [WJGlobalSingleton sharedInstance].companyid;
    
    if ([_topTitle isEqualToString:@"物业保修"]) {
        _postMOdel.tasktypeid = @"1";
    }else if ([_topTitle isEqualToString:@"物业保修"]){
        _postMOdel.tasktypeid = @"2";
    }else {
        _postMOdel.tasktypeid = @"3";
    }
    
    NSArray *titArr = @[@"标题:",@"",@"相关联系人:",@"联系人电话:"];
    _dataArr  = [NSMutableArray arrayWithArray:titArr];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight , SCREEN_HEIGHT, SCREEN_HEIGHT - kNavBarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    UIButton *subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [subButton addTarget:self action:@selector(subButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [subButton setTitle:@"提交" forState:UIControlStateNormal];
    [subButton setTitleColor:WhiteBackColor forState:UIControlStateNormal];
    subButton.backgroundColor = TEXTCOLOR(@"487DE5");
    subButton.titleLabel.font = FontOfSize(FontHugeSize);
    subButton.frame = CGRectMake((SCREEN_WIDTH-156)/2, SCREEN_HEIGHT - 200, 156, 42);
    [self.view addSubview:subButton];
    
    
   
}

#pragma mark - tableView delegata  and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 165;
    }else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"register";
    NSString *name = _dataArr[indexPath.row];
    
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.cellDelegate = self;
    
    if (indexPath.row == 1) {
        WETextView *textView= [[WETextView alloc] initWithFrame:CGRectMake(15, 16, SCREEN_HEIGHT - 30, 149)];
        textView.placeHolderLabel.text = @"具体内容，200字以内";
        textView.layer.borderWidth = 0;
        textView.Donedelegate = self;
        textView.backgroundColor = TEXTCOLOR(@"F5F5F5");
        textView.FontNumLabel.hidden = YES;
        textView.Num = 200;
        [cell.contentView addSubview:textView];
        cell.title.hidden = YES;
        cell.input.hidden = YES;
    }else {
        cell.title.text = _dataArr[indexPath.row];
        cell.input.placeholder = @"请输入";
        [UIView viewLinePoint:CGPointMake(15, 59) inView:cell.contentView length:SCREEN_WIDTH - 15 andAngle:0 lineColor:SepartorLineColor lineWidth:1];
    }
    cell.imageView.image = Image(name);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)getTextFieldDoneContent:(NSString *)str andCell:(id)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
            _postMOdel.tasktitle = str;
            break;
        case 2:
            _postMOdel.linkman = str;
            break;
        case 3:
            _postMOdel.linkphone = str;
            break;
            
        default:
            break;
    }
}
- (void)InputDone:(NSString *)textViewText {
    
    
    _postMOdel.taskcontent = textViewText;
}

-(void) subButtonClick{
    if (isBlankString(_postMOdel.tasktitle)) {
        ShowMessage(@"请填写标题", nil);
        return;
    }
    if (isBlankString(_postMOdel.taskcontent)) {
        ShowMessage(@"请填写具体内容", nil);
        return;
    }
    if (isBlankString(_postMOdel.linkman)) {
        ShowMessage(@"请填写联系人", nil);
        return;
    }
    if (isBlankString(_postMOdel.linkphone)) {
        ShowMessage(@"请填写联系人电话", nil);
        return;
    }
    NetWorkForTaskSubmit *net = [[NetWorkForTaskSubmit alloc] init];
    net.postModel = _postMOdel;
    [net startPostWithBlock:^(TaskSubmitRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
