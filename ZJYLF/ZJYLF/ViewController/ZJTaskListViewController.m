
//
//  ZJTaskListViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/3.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJTaskListViewController.h"
#import "NetWorkForTaskGetlist.h"
#import "TaskListCell.h"
#import "ZJTaskDetailViewController.h"

@interface ZJTaskListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NetWorkForTaskGetlist *net;
@end

@implementation ZJTaskListViewController
- (void)viewWillAppear:(BOOL)animated {
     self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"任务追踪";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight  , SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    self.net = [[NetWorkForTaskGetlist alloc] init];
    
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(MJrequest)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestNextData)];
    
    [self requestData];
}


- (void)MJrequest {
    _net.pageindex = @"1";
    _net.pagesize = @"20";
    
    [_net startGetWithBlock:^(TaskGetlistRespone * result, NSError *error) {
        [self.tableView.header endRefreshing];
        if ([result.code isEqualToString:@"200"]) {
            _dataArr = [NSMutableArray arrayWithArray:result.data.pagedata];
            if(_dataArr.count == 0){
                [self.tableView.footer  noticeNoMoreData];
            }
            if ([result.data.hasnextpage isEqual:@0]&&_dataArr.count !=0) {
                [self.tableView.footer noticeNoMoreData];
            }else{
                _net.pageindex=[NSString stringWithFormat:@"%d",[result.data.currentpageindex intValue]+1 ];
                [self.tableView.footer resetNoMoreData];
            }
            
            [self.tableView reloadData];
            
        }
    }];
}

- (void) requestData {
    _net.pageindex = @"1";
    _net.pagesize = @"20";
    [self startWithCursor];
    
    [_net startGetWithBlock:^(TaskGetlistRespone * result, NSError *error) {
        [self.tableView.header endRefreshing];
        [self stopWatiCursor];
        if ([result.code isEqualToString:@"200"]) {
            _dataArr = [NSMutableArray arrayWithArray:result.data.pagedata];
            if(_dataArr.count == 0){
                [self.tableView.footer  noticeNoMoreData];
            }
            if ([result.data.hasnextpage isEqual:@0]&&_dataArr.count !=0) {
                [self.tableView.footer noticeNoMoreData];
            }else{
                _net.pageindex=[NSString stringWithFormat:@"%d",[result.data.currentpageindex intValue]+1 ];
                [self.tableView.footer resetNoMoreData];
            }
            
            [self.tableView reloadData];
            
        }
    }];
}

- (void)requestNextData {
    [_net startGetWithBlock:^(TaskGetlistRespone * result, NSError *error) {
        [self.tableView.header endRefreshing];
        if ([result.code isEqualToString:@"200"]) {
            _dataArr = [NSMutableArray arrayWithArray:result.data.pagedata];
            if(_dataArr.count == 0){
                [self.tableView.footer  noticeNoMoreData];
            }
            if ([result.data.hasnextpage isEqual:@0]&&_dataArr.count !=0) {
                [self.tableView.footer noticeNoMoreData];
            }else{
                _net.pageindex=[NSString stringWithFormat:@"%d",[result.data.currentpageindex intValue]+1 ];
                [self.tableView.footer resetNoMoreData];
            }
            
            [self.tableView reloadData];
            
        }
    }];
}
#pragma mark - tableView delegata  and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskListCell *cell =(TaskListCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.bottomLine.bottom;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellid = @"registercell";
    TaskGetlistModel *model = _dataArr[indexPath.row];
    
    TaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[TaskListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskGetlistModel *model = _dataArr[indexPath.row];
    ZJTaskDetailViewController *vc = [[ZJTaskDetailViewController alloc] init];
    vc.taskid = [model.taskid stringValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
