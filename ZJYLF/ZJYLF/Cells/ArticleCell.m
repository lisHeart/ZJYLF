//
//  ArticleCell.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/25.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ArticleCell.h"

@implementation ArticleCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.picture = [[PictureView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 145, 15, 130,94)];
        [self.contentView addSubview:self.picture];
        
        self.content = [[UILabel alloc] init];
        self.content.font = FontOfSize(FontAlertSize);
        self.content.numberOfLines = 0;
        self.content.textColor = TEXTCOLOR(@"333333");
        [self.contentView addSubview:self.content];
        
        
        self.time = [[UILabel alloc] init];
        self.time.font = FontOfSize(FontAlertSize);
        self.time.textColor = TEXTCOLOR(@"333333");
        [self.contentView addSubview:self.time];
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = SepartorLineColor;
        [self.contentView addSubview:self.bottomLine];
        
     
    }
    
    return self;
}


- (void) setModel:(PageDataModel *)model {
    
   
   
    self.content.text = model.articletitle;
    
//    self.time.frame = CGRectMake(15, self.content.bottom + 30, 200, 20);
//    if ([model.typeid isEqual:@0]) {
//        self.time.text = [NSString stringWithFormat:@"公告：%@",model.createtime];
//    }else if ([model.typeid isEqual:@1]) {
//        self.time.text = [NSString stringWithFormat:@"互动：%@",model.createtime];
//    }else if ([model.typeid isEqual:@2]) {
//        self.time.text = [NSString stringWithFormat:@"政策：%@",model.createtime];
//    }else {
        self.time.text = [NSString stringWithFormat:@"%@",model.createtime];
    //}
    if (self.isShowPicture == NO) {
         CGFloat height = CalcTextHight(FontOfSize(FontAlertSize), model.articletitle, SCREEN_WIDTH  -35);
        self.picture.hidden = YES;
         self.content.frame = CGRectMake(15, 15, SCREEN_WIDTH  -35, height);
        self.time.frame = CGRectMake(15, self.content.bottom + 30, 200, 20);
        self.bottomLine.frame = CGRectMake(15, self.time.bottom +14, SCREEN_WIDTH -15, 1);
    }else{
         CGFloat height = CalcTextHight(FontOfSize(FontAlertSize), model.articletitle, SCREEN_WIDTH - 145 -65);
         self.content.frame = CGRectMake(15, 15, SCREEN_WIDTH - 145 -65, height);
        if (self.content.bottom+65>94+30 ) {
            self.time.frame = CGRectMake(15, self.content.bottom + 30, 200, 20);
            self.bottomLine.frame = CGRectMake(15, self.time.bottom +14, SCREEN_WIDTH -15, 1);
        }else {
            self.time.frame = CGRectMake(15, 89, 200, 20);
            self.bottomLine.frame = CGRectMake(15, 123, SCREEN_WIDTH - 15, 1);
        }
    }
    
   
    self.picture.defatultImage = Image(@"morem");
    self.picture.url = model.articlepicture;
    
    
    
    
    
}
@end
