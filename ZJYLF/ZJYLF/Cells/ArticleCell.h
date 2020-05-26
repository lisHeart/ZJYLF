//
//  ArticleCell.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/25.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkForArticleGetlist.h"
#import "PictureView.h"


@interface ArticleCell : UITableViewCell
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isShowPicture;
@property (nonatomic, strong) PictureView *picture;
@property (nonatomic, strong) PageDataModel *model;
@end
