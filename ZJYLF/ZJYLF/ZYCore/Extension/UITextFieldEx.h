//
//  UITextFieldEx.h
//  525JMobile
//
//  Created by songleilei on 15/11/4.
//  Copyright (c) 2015年 song leilei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITextFieldEx : UITextField{
    BOOL isEnablePadding;
    float paddingLeft;
    float paddingRight;
    float paddingTop;
    float paddingBottom;
}

- (void)setPadding:(BOOL)enable top:(float)top right:(float)right bottom:(float)bottom left:(float)left;

@end
