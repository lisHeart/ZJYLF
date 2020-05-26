//
//  ZJArticleViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/26.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJArticleViewController.h"
#import "ArticleCell.h"
#import "NetWorkForArticleGetlist.h"
#import "ZJArticleDetailViewController.h"

@interface ZJArticleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
//@property (strong, nonatomic) ArticleGetlistPostmodel *postModel;
@property (nonatomic, strong) NetWorkForArticleGetlist *net;
@end

@implementation ZJArticleViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.Articletype isEqualToString:@"Recruitment"]) {
        self.titleLab.text = @"企业招聘";
        
    }else  if([self.Articletype isEqualToString:@"CompanyIntroduction"]){
        self.titleLab.text = @"入驻企业";
    }else if([self.Articletype isEqualToString:@"Policy"]) {
        self.titleLab.text = @"政策资讯";
    }else if([self.Articletype isEqualToString:@"Bulletin"]){
         self.titleLab.text = @"园区动态";
    }else {
        self.titleLab.text = @"园区公告";
    }
    
    _net = [[NetWorkForArticleGetlist alloc] init];
    _net.Articletype = self.Articletype;
    
    
    [self requestData];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-kNavBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(MJrequest)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestNextData)];

   
}
- (void)MJrequest {
    _net.Pageindex = @"1";
    _net.Pagesize = @"20";
 

    [_net startGetWithBlock:^(ArticleGetlistRespone * result, NSError *error) {
         [self.tableView.header endRefreshing];
        if ([result.code isEqualToString:@"200"]) {
            _dataArr = [NSMutableArray arrayWithArray:result.data.pagedata];
            if(_dataArr.count == 0){
                [self.tableView.footer  noticeNoMoreData];
            }
                if ([result.data.hasnextpage isEqual:@0]&&_dataArr.count !=0) {
                    [self.tableView.footer noticeNoMoreData];
                }else{
                     _net.Pageindex=[NSString stringWithFormat:@"%d",[result.data.currentpageindex intValue]+1];
                    [self.tableView.footer resetNoMoreData];
                }
                
                [self.tableView reloadData];
            
        }
    }];
}

- (void)requestData {
    _net.Pageindex = @"1";
    _net.Pagesize = @"20";
    [self startWithCursor];
    [_net startGetWithBlock:^(ArticleGetlistRespone * result, NSError *error) {
        [self stopWatiCursor];
        if ([result.code isEqualToString:@"200"]) {
            _dataArr = [NSMutableArray arrayWithArray:result.data.pagedata];
            if(_dataArr.count == 0){
                [self.tableView.footer  noticeNoMoreData];
            }
                if ([result.data.hasnextpage isEqual:@0]&&_dataArr.count !=0) {
                    [self.tableView.footer noticeNoMoreData];
                }else{
                    _net.Pageindex=[NSString stringWithFormat:@"%d",[result.data.currentpageindex intValue]+1];
                    [self.tableView.footer resetNoMoreData];
                }
                
                [self.tableView reloadData];
            
        }
    }];
}

- (void)requestNextData {
    [_net startGetWithBlock:^(ArticleGetlistRespone * result, NSError *error) {
        [self.tableView.header endRefreshing];
        if ([result.code isEqualToString:@"200"]) {
            [_dataArr addObjectsFromArray:result.data.pagedata];
            if(_dataArr.count == 0){
                [self.tableView.footer  noticeNoMoreData];
            }
                if ([result.data.hasnextpage isEqual:@0]&&_dataArr.count !=0) {
                    [self.tableView.footer noticeNoMoreData];
                }else{
                    _net.Pageindex=[NSString stringWithFormat:@"%d",[result.data.currentpageindex intValue]+1];
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
    ArticleCell  *cell = (ArticleCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.bottomLine.bottom;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"register";
    NSString *name = _dataArr[indexPath.row];
    PageDataModel *model = _dataArr[indexPath.row];
    ArticleCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if ([self.Articletype isEqualToString:@"Recruitment"]||[self.Articletype  isEqualToString:@"Bulletin"]) {
        cell.isShowPicture = NO;
    }else {
        cell.isShowPicture = YES;
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PageDataModel *model = _dataArr[indexPath.row];
    ZJArticleDetailViewController *vc = [[ZJArticleDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
