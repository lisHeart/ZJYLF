//
//  ProgressCell.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ProgressCell.h"

@implementation ProgressCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.numLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 25, 20, 20)];
        self.numLab.textColor = WhiteBackColor;
        self.numLab.layer.masksToBounds = YES;
        self.numLab.layer.borderColor = [UIColor clearColor].CGColor;
        self.numLab.layer.cornerRadius = 10;
        self.numLab.layer.borderWidth = 0.5;
        self.numLab.font = FontOfSize(14);
        self.numLab.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.numLab];
        
        self.linview = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 2, 19)];
        [self.contentView addSubview:self.linview];
        
        self.lineView1 = [[UIView alloc] initWithFrame:CGRectMake(25, _numLab.bottom + 6, 2, 19)];
        [self.contentView addSubview:self.lineView1];
        
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(44, 8, SCREEN_WIDTH - 60, 54)];
        [self.contentView addSubview:self.backImage];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(68, 21, 150, 24)];
        self.title.font = FontOfSize(20);
        [self.contentView addSubview:self.title];
        
    }
    return self;
}


@end
