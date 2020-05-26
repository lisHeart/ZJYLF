//
//  CustomTabBar.m
//  CustomTabBarController
//
//  Created by Hu Zhiqiang on 22/05/2012.
//  Copyright (c) 2012 __My Computer__. All rights reserved.
//

#import "CustomWorkersTabBar.h"

@implementation CustomWorkersTabBar
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;

- (id)initWithButtonImages:(NSArray *)imageArray titleArray:(NSArray*)titleArray
{
    self = [super init];
    if (self){
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWCScreenSize.width, 1)];
        lineLabel.backgroundColor = TEXTCOLOR(@"dddddf");
        [self addSubview:lineLabel];
        self.backgroundColor = [UIColor whiteColor];
        
		self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
        int offX = 0;
        float width = SCREEN_WIDTH/imageArray.count+0.4; //320/30=106.6 3个106.6 加起来不够320，所以需要添加0.4

		for (int i = 0; i < [imageArray count]; i++){
			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor redColor];
			btn.tag = i;
			btn.frame = CGRectMake(offX, 1, width, 59);
            btn.backgroundColor = [UIColor whiteColor];
            offX += width;

            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.tag = i;
            imgBtn.frame = CGRectMake(0, 12, 22, 22);
            imgBtn.left = (btn.width - imgBtn.width)/2;
            [btn addSubview:imgBtn];

            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            titleBtn.tag = i;
            titleBtn.frame = CGRectMake(0, 0, width, 12);
            titleBtn.top = imgBtn.bottom+5;
            titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 11.0];

            [titleBtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [titleBtn setTitleColor:ContentTextColor forState:UIControlStateNormal];
            [titleBtn setTitleColor:MainBackColor forState:UIControlStateSelected];
            [titleBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:titleBtn];
imgBtn.backgroundColor = [UIColor redColor];
            [imgBtn setBackgroundImage:[[imageArray objectAtIndex:i] objectForKey:@"Default"]  forState:UIControlStateNormal];
            [imgBtn setBackgroundImage:[[imageArray objectAtIndex:i] objectForKey:@"Seleted"]  forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[self.buttons addObject:btn];
			[self addSubview:btn];
		}
    }
    return self;
}



- (void)tabBarButtonClicked:(id)sender{
        UIButton *btn = sender;
        [self selectTabAtIndex:btn.tag];
    
    
        if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]){
            
            [_delegate tabBar:self didSelectIndex:btn.tag];
        }
}

- (void)selectTabAtIndex:(NSInteger)index {
    for (int i = 0; i < [self.buttons count]; i++) {
        UIButton *imgBtn   = [[[self.buttons objectAtIndex:i] subviews] objectAtIndex:0];
        UIButton *titleBtn = [[[self.buttons objectAtIndex:i] subviews] objectAtIndex:1];
        imgBtn.selected    = NO;
        titleBtn.selected  = NO;
    }
    
    UIButton *imgBtn   = [[[self.buttons objectAtIndex:index] subviews] objectAtIndex:0];
    UIButton *titleBtn = [[[self.buttons objectAtIndex:index] subviews] objectAtIndex:1];
    imgBtn.selected    = YES;
    titleBtn.selected  = YES;
}



@end
