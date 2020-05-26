//
//  CountDownTimeButton.h
//  定时器
//
//  Created by ainolee on 15/9/17.

//

#import <UIKit/UIKit.h>

/*
 只有纯代码才能使用
 注意设置的时候需要根据title的长度改变btn的font的大小
 背景颜色和问题颜色需要在.m中设置
 */
@interface CountDownTimeButton : UIButton
{
    int _totalSecond;//总时间
    NSTimer *_timer;//定时器
    NSString *_startTitle;//点击开始计时
}


-(instancetype)initWithFrame:(CGRect)frame WithBtnTitle:(NSString *)startTitle;
-(void)startWithSecond:(int)totalSecond;

@end
