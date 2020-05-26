//
//  TaskListCell.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/3.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkForTaskGetlist.h"

@interface TaskListCell : UITableViewCell
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *state;
@property (nonatomic, strong) TaskGetlistModel *model;
@property (nonatomic, strong) UIView *bottomLine;
@end
