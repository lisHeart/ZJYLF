//
//  EquipmentCell.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/27.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureView.h"
#import "NetWorkForReservationGetlist.h"

@interface EquipmentCell : UITableViewCell
@property (nonatomic, strong) PictureView *headView;
@property (nonatomic, strong) UIImageView *head1;
@property (nonatomic, strong) UIImageView *head2;
@property (nonatomic, strong) UIImageView *head3;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) ReservationGetlistModel *model;
@end
