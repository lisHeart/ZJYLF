//
//  TableViewCell.m
//  525JMobile
//
//  Created by xiang.wu on 2017/3/17.
//  Copyright © 2017年 song leilei. All rights reserved.
//

#import "UILabel+AlertActionFont.h"

@implementation UILabel (AlertActionFont)

- (void)setApperanceFont:(UIFont *)apperanceFont {
    if (apperanceFont) {
        [self setFont:apperanceFont];
    }
}

- (UIFont *)apperanceFont {
    return self.font;
}

@end
