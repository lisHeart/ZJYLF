//
//  ZJTaskDetailViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/3.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJTaskDetailViewController.h"
#import "NetWorkForTaskGet.h"
#import "replyCell.h"

@interface ZJTaskDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *headView;
}

@property (nonatomic, strong) TaskGetResponeModel *model;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ZJTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"详细信息";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight  , SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    [self requestData];
    
}

- (void) requestData {
    NetWorkForTaskGet *net = [[NetWorkForTaskGet alloc] init];
    net.taskid = _taskid;
    [net startGetWithBlock:^(TaskGetRespone * result, NSError *error) {
        if ([result.code  isEqualToString:@"200"]) {
            _dataArr = [NSMutableArray arrayWithArray:result.data.replies];
            self.model = result.data;
            [self initUI];
            _tableView.tableHeaderView = headView;
            
            [_tableView reloadData];
        }
    }];
}
- (void) initUI {
    headView = [[UIView alloc] init];
    
    CGFloat height = CalcTextHight(FontOfSize(12), _model.taskcontent, SCREEN_WIDTH - 30);
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(15,  16, SCREEN_WIDTH -30, 18)];
     title.text = [NSString stringWithFormat:@"【%@】%@",_model.tasktypename,_model.tasktitle];
    title.textColor = DeepBlackTextColor;
    title.font = BoldFontOfSize(16);
    [headView addSubview:title];
    
    [UIView viewLinePoint:CGPointMake(15, title.bottom +15) inView:headView length:SCREEN_WIDTH-30 andAngle:0 lineColor:SepartorLineColor lineWidth:1];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, title.bottom +30, 200, 36)];
    name.text = [NSString stringWithFormat:@"提交企业：%@\n提交人姓名:%@",_model.companyname,_model.linkman];
    name.numberOfLines = 0;
    name.textColor = TEXTCOLOR(@"999999");
    name.font = FontOfSize(14);
    [headView addSubview:name];
    
    UILabel * state = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 72, title.bottom + 39, 56, 18)];
    state.font = FontOfSize(FontNormalSize);
    state.layer.borderColor = MainBackColor.CGColor;
    state.layer.borderWidth = 1;
    state.text = _model.statename;
    if ([_model.statename isEqualToString:@"处理中"]) {
        state.backgroundColor = MainBackColor;
        state.textColor = WhiteBackColor;
    }else {
        state.backgroundColor = WhiteBackColor;
        state.textColor = MainBackColor;
    }
    state.layer.cornerRadius = 10;
    state.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:state];
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(15, name.bottom + 20, SCREEN_WIDTH - 30, height)];
    content.text = _model.taskcontent;
    content.textColor = DeepBlackTextColor;
    content.font = FontOfSize(14);
    [headView addSubview:content];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 200, content.bottom + 15, 185, 15)];
    time.textColor = DeepBlackTextColor;
    time.text = _model.createtime;
    time.font = FontOfSize(14);
    time.textAlignment = NSTextAlignmentRight;
    [headView addSubview:time];
    
    
    if (_dataArr.count == 0) {
        headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, time.bottom+20);
    }else {
        
        [UIView viewLinePoint:CGPointMake(0, time.bottom +15) inView:headView length:SCREEN_WIDTH andAngle:0 lineColor:SepartorLineColor lineWidth:8];
        [UIView viewLinePoint:CGPointMake(15, time.bottom +32) inView:headView length:16 andAngle:M_PI/2 lineColor:MainBackColor lineWidth:2];
        
        UILabel *replay = [[UILabel alloc] initWithFrame:CGRectMake(17, time.bottom +32, 200, 16)];
        replay.text = @"回复信息";
        replay.textColor = DeepBlackTextColor;
        replay.font = FontOfSize(14);
        [headView addSubview:replay];
        
         headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, replay.bottom);
    }

    
    
    
    
    
}
#pragma mark - tableView delegata  and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    replyCell *cell =(replyCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.time.bottom+10;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellid = @"registercell";
    repliesModel *model = _dataArr[indexPath.row];
    
    replyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[replyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
    
}

- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
