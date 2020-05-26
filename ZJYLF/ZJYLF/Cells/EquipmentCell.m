//
//  EquipmentCell.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/27.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "EquipmentCell.h"

@implementation EquipmentCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headView = [[PictureView alloc] initWithFrame:CGRectMake(15, 15, 130, 94)];
        [self.contentView addSubview:self.headView];
        
        self.head1 = [[UIImageView alloc] initWithFrame:CGRectMake(_headView.right +10, 15, 18, 16)];
        [self.contentView addSubview:self.head1];
        
        self.head2 = [[UIImageView alloc] init];
        [self.contentView addSubview:self.head2];
        
        self.head3 = [[UIImageView alloc] init];
        [self.contentView addSubview:self.head3];
        self.label1 = [[UILabel alloc] init];
        self.label2 = [[UILabel alloc] init];
        self.label3 = [[UILabel alloc] init];
        
        NSArray *labelArr = @[self.label1,self.label2,self.label3];
        for ( __strong UILabel * label in labelArr) {
            label.textColor = ContentTextColor;
            label.numberOfLines = 0;
            label.font = FontOfSize(FontNormalSize);
            [self.contentView addSubview:label];
        }
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = SepartorLineColor;
        [self.contentView addSubview:self.bottomLine];
        
        
        
    }
    return self;
}

- (void) setModel:(ReservationGetlistModel *)model {
    CGFloat height = 0;
    NSString *str = [NSString stringWithFormat:@"租用时间:%@",model.hiretime];
    height = CalcTextHight(FontOfSize(FontNormalSize), str, SCREEN_WIDTH - _head1.right-20);
    _head2.frame = CGRectMake(_headView.right +10, _head1.bottom +15, 18, 16);
    _label1.frame = CGRectMake(_head1.right +10,15, SCREEN_WIDTH - _head1.right-20, 16);
    _label2.frame = CGRectMake(_head1.right +10,_head1.bottom +15, SCREEN_WIDTH - _head1.right-20, height);
    _head3.frame = CGRectMake(_headView.right +10, _label2.bottom +15, 18, 16);
     _label3.frame = CGRectMake(_head1.right +10,_label2.bottom +15, SCREEN_WIDTH - _head1.right-20, 16);
    
    _bottomLine.frame = CGRectMake(15, _label3.bottom +10, SCREEN_WIDTH-30, 1);
    _head1.image = Image(@"租用企业");
    _head2.image = Image(@"租用时间");
    _head3.image = Image(@"人数");
    
    _label1.text = [NSString stringWithFormat:@"租用企业:%@",model.hirecompany];
    _label2.text = str;
    _label3.text = [NSString stringWithFormat:@"人数：%@人",model.usenumber];
    
    _headView.url = model.equipmentimage;
    _headView.defatultImage = Image(@"moren");
    
    
    
    
    
}
@end
