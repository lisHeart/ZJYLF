//
//  TaskListCell.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/3.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "TaskListCell.h"

@implementation TaskListCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH -30, 16)];
        self.title.textColor = ContentTextColor;
        self.title.font = BoldFontOfSize(14);
        [self.contentView addSubview:self.title];
        
        self.content = [[UILabel alloc] init];
        self.content.textColor = ContentTextColor;
        self.content.font = FontOfSize(12);
        self.content.numberOfLines = 0;
        [self.contentView addSubview:self.content];
        
        self.time = [[UILabel alloc] init];
        self.time.textColor = ContentTextColor;
        self.time.font = FontOfSize(FontNormalSize);
        [self.contentView addSubview:self.time];
        
        self.state = [[UILabel alloc] init];
        self.state.font = FontOfSize(FontNormalSize);
        self.state.layer.borderColor = MainBackColor.CGColor;
        self.state.layer.borderWidth = 1;
        self.state.layer.cornerRadius = 10;
        self.state.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.state];
        
        self.bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = SepartorLineColor;
        [self.contentView addSubview:_bottomLine];
        
        
    }
    
    return self;
}
- (void) setModel:(TaskGetlistModel *)model {
    CGFloat height = CalcTextHight(FontOfSize(12), model.taskcontent, SCREEN_WIDTH - 30);
    _content.frame = CGRectMake(15, _title.bottom +15, SCREEN_WIDTH -30, height);
    _content.text = model.taskcontent;
    _title.text = [NSString stringWithFormat:@"【%@】%@",model.tasktypename,model.tasktitle];
    _time.frame = CGRectMake(15, _content.bottom +20, 200, 20);
    _time.text = model.createtime;
    
    _state.frame = CGRectMake(SCREEN_WIDTH - 72, _content.bottom +20, 56, 18);
    
    if ([model.statename isEqualToString:@"处理中"]) {
        self.state.backgroundColor = MainBackColor;
        self.state.textColor = WhiteBackColor;
    }else {
        self.state.backgroundColor = WhiteBackColor;
        self.state.textColor = MainBackColor;
    }
    _state.text = model.statename;
    _bottomLine.frame = CGRectMake(15, _state.bottom +15, SCREEN_WIDTH-30, 1);
    
}
@end
