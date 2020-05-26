//
//  replyCell.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/4.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "replyCell.h"

@implementation replyCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.content = [[UILabel alloc] init];
        self.content.font = FontOfSize(14);
        self.content.textColor = DeepBlackTextColor;
        self.content.numberOfLines = 0;
        [self.contentView addSubview:self.content];
        
        self.time = [[UILabel alloc] init];
        self.time.font = FontOfSize(14);
        self.time.textColor = DeepBlackTextColor;
        self.time.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.time];
    }
    return self;
}
- (void)setModel:(repliesModel *)model {
    CGFloat height = CalcTextHight(FontOfSize(14), model.replycontent, SCREEN_WIDTH-30);
    _content.text = model.replycontent;
    _content.frame = CGRectMake(15, 15, SCREEN_WIDTH-30, height);
    
    _time.text = model.createtime;
    _time.frame = CGRectMake(SCREEN_WIDTH - 200, _content.bottom + 15, 185, 15);
}
@end
