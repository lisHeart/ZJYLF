//
//  EquipTableViewCell.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/27.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "EquipTableViewCell.h"

@implementation EquipTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
        
        self.titLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, 66, 20)];
        self.titLabel.font = FontOfSize(FontAlertSize);
        self.titLabel.textColor = TEXTCOLOR(@"333333");
        [self.contentView addSubview:self.titLabel];
        
        self.input = [[UITextField alloc] initWithFrame:CGRectMake(_titLabel.right + 10, 17, SCREEN_WIDTH - _titLabel.right-55, 20)];
        [self.input addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        self.input.textColor = TEXTCOLOR(@"4E82E7");
        self.input.font = FontOfSize(FontAlertSize);
        self.input.textAlignment = NSTextAlignmentRight;
        self.input.delegate = self;
        [self.contentView addSubview:self.input];
        
        //箭头
       self.aronView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-31, 19.5, 16, 16)];
        _aronView.image = Image(@"去选择企业");
        [self.contentView addSubview:_aronView];
        
        [UIView viewLinePoint:CGPointMake(15, 54) inView:self.contentView length:SCREEN_WIDTH - 55 andAngle:0 lineColor:TEXTCOLOR(@"ebebeb") lineWidth:1.0f];
    }
    return self;
}


- (void)textFieldEditChanged:(UITextField *)textField {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(getTextFieldDoneContent:andCell:)]) {
        [self.cellDelegate getTextFieldDoneContent:textField.text andCell:self];
    }
    
}

@end
