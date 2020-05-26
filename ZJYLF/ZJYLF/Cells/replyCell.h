//
//  replyCell.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/4.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkForTaskGet.h"

@interface replyCell : UITableViewCell
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) repliesModel *model;

@end
