//
//  ZJEquipmentHomeViewController.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/26.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ZJEquipmentHomeViewController.h"
#import "EquipTableViewCell.h"
#import "NetWorkForReservationGetlist.h"'
#import "EquipmentCell.h"
#import "LYLOptionPicker.h"
#import "LYLDatePicker.h"
#import "NetWorkForGetEquipmentName.h"
#import "NetWorkForReservationSubmit.h"


@interface ZJEquipmentHomeViewController ()<UITableViewDelegate,UITableViewDataSource,cellTextFieldDelegete>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, strong) NSArray *equipmentArr;
@property (nonatomic, strong) ReservationSubmitPostmodel *postModel;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NetWorkForReservationGetlist *net;

@end

@implementation ZJEquipmentHomeViewController
- (void)viewWillAppear:(BOOL)animated {
     self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"设备预定/查看预定";
    
    _buttonArr = [NSMutableArray array];
    
    _postModel = [[ReservationSubmitPostmodel alloc] init];
    
    self.net = [[NetWorkForReservationGetlist alloc] init];
    
    NSArray *nameArr = @[@"预定设备",@"查看预定"];
    CGFloat width = SCREEN_WIDTH/2;
    for (NSString * name in nameArr) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:ContentTextColor forState:UIControlStateNormal];
        [button setTitleColor:MainBackColor forState:UIControlStateSelected];
        button.titleLabel.font = BoldFontOfSize(FontAlertSize);
        [button addTarget:self action:@selector(selectSwitch:) forControlEvents:UIControlEventTouchUpInside];
        if ([name isEqualToString:@"预定设备"]) {
            button.selected = YES;
            button.frame = CGRectMake((width -100)/2, kNavBarHeight+13, 100, 20);
        }else {
             button.frame = CGRectMake((width -100)/2 +width, kNavBarHeight+13, 100, 20);
        }
        [self.view addSubview:button];
        [_buttonArr addObject:button];
    }
    [UIView viewLinePoint:CGPointMake(width, kNavBarHeight + 15) inView:self.view length:16 andAngle:M_PI/2 lineColor:TEXTCOLOR(@"979797") lineWidth:2];
    
    [UIView viewLinePoint:CGPointMake(0, kNavBarHeight + 46) inView:self.view length:SCREEN_WIDTH andAngle:0 lineColor:ViewBackGroundColor lineWidth:8];
    NSArray *titArr = @[@"设备名称",@"使用人数",@"使用日期",@"使用时间"];
    _dataArr = [NSMutableArray arrayWithArray:titArr];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 54 , SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight-54)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(MJrequest)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestNextData)];
    self.tableView.gifHeader.hidden=YES;
    self.tableView.legendFooter.hidden = YES;
    
    [self getEquipName];
    
    
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    UIButton *sureBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBUtton addTarget:self action:@selector(subClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBUtton setTitle:@"提交" forState:UIControlStateNormal];
    [sureBUtton setTitleColor:WhiteBackColor forState:UIControlStateNormal];
    sureBUtton.backgroundColor = TEXTCOLOR(@"487DE5");
    sureBUtton.titleLabel.font = FontOfSize(FontHugeSize);
    sureBUtton.frame = CGRectMake((SCREEN_WIDTH-240)/2, 40, 240, 40);
    [self.footView addSubview:sureBUtton];
    
    self.tableView.tableFooterView = _footView;
    
    
    
}
- (void) getEquipName{
    NetWorkForGetEquipmentName *net = [[NetWorkForGetEquipmentName alloc] init];
    [net startGetWithBlock:^(EquipmentNameRespone * result, NSError *error) {
        _equipmentArr = [NSArray arrayWithArray:result.data];
    }];
}

- (void) subClick {
    NetWorkForReservationSubmit *net = [[NetWorkForReservationSubmit alloc] init];
    _postModel.companyid = [WJGlobalSingleton sharedInstance].companyid;
    _postModel.submitor = [WJGlobalSingleton sharedInstance].userid;
    net.postModel = _postModel;
    [net startPostWithBlock:^(ReservationSubmitRespone * result, NSError *error) {
        if ([result.code isEqualToString:@"200"]) {
            ShowMessage(@"提交设备成功", nil);
            
        }
    }];
}
- (void)MJrequest {
    _net.pageindex = @"1";
    _net.pagesize = @"20";

    [_net startGetWithBlock:^(ReservationGetlistRespone * result, NSError *error) {
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
   
    [_net startGetWithBlock:^(ReservationGetlistRespone * result, NSError *error) {
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
    [_net startGetWithBlock:^(ReservationGetlistRespone * result, NSError *error) {
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
    if (self.tableView.gifHeader.hidden) {
        return 55;
    }else {
        EquipmentCell *cell =(EquipmentCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.bottomLine.bottom;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableView.gifHeader.hidden) {
        static NSString *cellid = @"register";
        NSString *name = _dataArr[indexPath.row];
        
        EquipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        
        if (!cell) {
            cell = [[EquipTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        if (indexPath.row == 1) {
            cell.input.enabled = YES;
        }else {
            cell.input.enabled = NO;
        }
        cell.cellDelegate = self;
        
        cell.titLabel.text = name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        static NSString *cellid = @"registercell";
        ReservationGetlistModel *model = _dataArr[indexPath.row];
        
        EquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        
        if (!cell) {
            cell = [[EquipmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
  
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.gifHeader.hidden) {
         EquipTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 2) {
            [LYLDatePicker showDateDetermineChooseInView:self.view determineChoose:^(NSString *dateString) {
                NSLog(@"%@",dateString);
                cell.input.text = dateString;
                _time = dateString;
            }];
        }else if (indexPath.row == 3){
            
            [LYLOptionPicker showOptionPickerInView:self.view dataSource:@[@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"],@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"]] determineChoose:^(NSArray *indexes, NSArray *selectedItems) {
                
                NSLog(@"%@,%@",indexes,selectedItems);
                cell.input.text = [NSString stringWithFormat:@"时间： %@-%@",selectedItems[0],selectedItems[1]];
                _postModel.starttime = [NSString stringWithFormat:@"%@ %@:00",_time,selectedItems[0]];
                _postModel.endtime = [NSString stringWithFormat:@"%@ %@:00",_time,selectedItems[1]];
                
                
            }];
           
        }else if (indexPath.row == 0){
           
            UIAlertController *alert    = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            __weak typeof(self) weakSelf = self;
            for (EquipmentNameModel *model in self.equipmentArr ) {
                UIAlertAction *action =  [UIAlertAction actionWithTitle:model.equipmentname style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    cell.input.text = model.equipmentname;
                    _postModel.equipmentid = model.equipmentid;
                    
//                    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }];
                
                
                [alert addAction:action];
                
            }
            
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void) selectSwitch:(UIButton *) sender{
    
    if (sender.selected ==YES) {
        return;
    }
    for (UIButton *button in _buttonArr) {
        button.selected = !button.selected;
    }
    if ([sender.titleLabel.text isEqualToString:@"预定设备"]) {
        self.tableView.gifHeader.hidden=YES;
        self.tableView.legendFooter.hidden = YES;
        NSArray *titArr = @[@"设备名称",@"使用人数",@"使用日期",@"使用时间"];
        _dataArr = [NSMutableArray arrayWithArray:titArr];
        self.tableView.tableFooterView = _footView;
        [_tableView reloadData];
    }else {
        self.tableView.gifHeader.hidden=NO;
        self.tableView.legendFooter.hidden = NO;
        self.tableView.tableFooterView = nil;
        [self requestData];
    }
    
}

- (void)getTextFieldDoneContent:(NSString *)str andCell:(id)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
   
            _postModel.staffnum = str;
     
}
- (void)backToUpper {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
