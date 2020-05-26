//
//  HomeCollectionViewCell.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/20.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = SCREEN_WIDTH/4;
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 70)];
        backView.layer.cornerRadius = 4;
        backView.backgroundColor = TEXTCOLOR(@"fafafa");
        backView.layer.borderWidth = 0.5;
        backView.layer.borderColor = TEXTCOLOR(@"fafafa").CGColor;
        [self.contentView addSubview:backView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.width - 60, 13, 49, 49)];
        [backView addSubview:self.imageView];
        //名称
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, backView.width-80, 15)];
        self.nameLabel.font= BoldFontOfSize(15);
        self.nameLabel.textColor = DeepBlackTextColor;
        [backView addSubview: self.nameLabel];
    
        
    }
    
    return self;
}
@end
