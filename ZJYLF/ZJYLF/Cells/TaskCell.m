//
//  TaskCell.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/24.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(15, 25,100, 20)];
        self.title.font = FontOfSize(FontAlertSize);
        self.title.textColor = TEXTCOLOR(@"333333");
        [self.contentView addSubview:self.title];
        
        self.input = [[UITextField alloc] initWithFrame:CGRectMake(_title.right + 10, 25, SCREEN_WIDTH - _title.right-15, 20)];
        [self.input addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        self.input.delegate = self;
        [self.contentView addSubview:self.input];
    }
    return self;
}


- (void)textFieldEditChanged:(UITextField *)textField {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(getTextFieldDoneContent:andCell:)]) {
        [self.cellDelegate getTextFieldDoneContent:textField.text andCell:self];
    }
    
}
@end
