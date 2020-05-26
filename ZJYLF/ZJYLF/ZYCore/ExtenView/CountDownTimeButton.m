//
//  CountDownTimeButton.m
//  定时器
//
//  Created by ainolee on 15/9/17.
//

#import "CountDownTimeButton.h"

@implementation CountDownTimeButton


-(void)dealloc
{
    //销毁
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}
//没有点击的时候的标题
-(instancetype)initWithFrame:(CGRect)frame WithBtnTitle:(NSString *)startTitle
{
    if (self=[super initWithFrame:frame]) {
        _startTitle=startTitle;
        [self setTitle:startTitle forState:UIControlStateNormal];
        [self setTitleColor:TEXTCOLOR(@"487DE5") forState:UIControlStateNormal];
         self.backgroundColor=WhiteBackColor;
        
    }
    return self;
}

//开始计时
-(void)startWithSecond:(int)totalSecond
{
    _totalSecond=totalSecond;
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChangeStart:) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantPast]];
}
-(void)timeChangeStart:(NSTimer *)timer
{
    if (_totalSecond>1) {
        self.enabled=NO;
        _totalSecond--;
        [self setTitle:[NSString stringWithFormat:@"%d秒倒计时",_totalSecond] forState:UIControlStateNormal];
    }
    else
    {
        self.enabled=YES;
        [_timer setFireDate:[NSDate distantFuture]];
        [self setTitle:_startTitle forState:UIControlStateNormal];
       
       // [self setTitleColor:TEXTCOLOR(@"0xE62F17") forState:UIControlStateNormal];
         self.backgroundColor=TEXTCOLOR(@"0xE62F17");

    }
    
}


@end
