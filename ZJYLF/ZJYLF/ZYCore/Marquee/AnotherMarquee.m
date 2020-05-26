//
//  AnotherMarquee.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/11/8.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "AnotherMarquee.h"
#import "UIView+HHAddition.h"
@interface AnotherMarquee()
@property(assign, nonatomic)int titleIndex;
@property(assign, nonatomic)int index;
@property (nonatomic) NSMutableArray *titles;
/**第一个*/
@property(nonatomic)UIButton *firstButton;
/**更多个*/
@property(nonatomic)UIButton *moreBtn;
@end
@implementation AnotherMarquee

#pragma mark - init Methods
-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray *)titles{
    
    if (self = [super initWithFrame:frame]) {
        _titleArr  = titles;
        self.titleColor = [UIColor blackColor];
        self.titleFont =  [UIFont systemFontOfSize:14];
        self.clipsToBounds = YES;
        
        UIImageView *companylineView = [[UIImageView alloc] initWithFrame:CGRectMake(21, (self.frame.size.height - 18 )/2, 3, 18)];
        companylineView.image = Image(@"蓝色竖线") ;
        [self addSubview:companylineView];
        
        UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, (self.frame.size.height - 20 )/2, 60, 20)];
        tagLabel.text = @"企业招聘";
        tagLabel.textColor =MainBackColor;
        tagLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:tagLabel];
        
        
        NSMutableArray *MutableTitles = [NSMutableArray arrayWithArray:titles];
        NSString *str = @"";
        self.titles = MutableTitles;
        [self.titles addObject:str]; //加一个空的,防止数组为空奔溃
        self.index = 1;
        self.firstButton = [self btnframe:CGRectMake(CGRectGetMaxX(tagLabel.frame)+10, 0, [UIScreen mainScreen].bounds.size.width - 90-55, self.bounds.size.height)  titleColor:_titleColor action:@selector(clickBtn:)];
        self.firstButton .tag = self.index;
        [self.firstButton  setTitle:self.titles[0] forState:UIControlStateNormal];
        [self addSubview:self.firstButton];
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextAd) userInfo:nil repeats:YES];
        
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame = CGRectMake(SCREEN_WIDTH - 55, (self.frame.size.height - 35 )/2, 50, 35);
        [moreButton setImage:Image(@"蓝色竖线") forState:UIControlStateNormal];
        [moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:MainBackColor forState:UIControlStateNormal];
        moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [moreButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        moreButton.titleLabel.font = FontOfSize(12);
        [self addSubview:moreButton];
        
    }
    
    return self;
}

#pragma mark - SEL Methods
-(void)nextAd{
    UIButton *firstButton = [self viewWithTag:self.index];
    self.moreBtn = [self btnframe: CGRectMake(90, self.bounds.size.height,[UIScreen mainScreen].bounds.size.width -90-55
                                              , self.bounds.size.height)  titleColor:_titleColor action:@selector(clickBtn:)];
    self.moreBtn.tag = self.index + 1;
    if ([self.titles[self.titleIndex+1] isEqualToString:@""]) {
        self.titleIndex = -1;
        self.index = 0;
    }
    if (self.moreBtn.tag == self.titles.count) {
        
        self.moreBtn.tag = 1;
    }
    [self.moreBtn setTitle:self.titles[self.titleIndex+1] forState:UIControlStateNormal];
    [self addSubview:self.moreBtn];
    
    [UIView animateWithDuration:0.25 animations:^{
        firstButton.y = -self.bounds.size.height;
        self.moreBtn.y = 0;
        
    } completion:^(BOOL finished) {
        [firstButton removeFromSuperview];
        
    } ];
    self.index++;
    self.titleIndex++;
}
-(void)clickBtn:(UIButton *)btn{
    
    if (self.handlerTitleClickCallBack) {
        self.handlerTitleClickCallBack(btn.tag);
    }
}

-(void)moreClick{
    if (self.moreClickCallBack) {
        self.moreClickCallBack();
        
    }
}

#pragma mark - Custom Methods
- (UIButton *)btnframe:(CGRect)frame  titleColor:(UIColor *)titleColor action:(SEL)action{
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = frame;
    btn.titleLabel.font = _titleFont;
    //靠左 不居中显示
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;////文字多出部分 在右侧显示点点
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
#pragma mark - Setter && Getter Methods
- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [self.firstButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:titleColor forState:UIControlStateNormal];
    
}
- (void)setTitleFont:(UIFont *)titleFont{
    
    _titleFont = titleFont;
    self.firstButton.titleLabel.font = titleFont;
    self.moreBtn.titleLabel.font = titleFont;
    
}

@end
