//
//  AddPictureCell.m
//  525JMobile
//
//  Created by iOS developer on 15/10/14.
//  Copyright (c) 2015年 song leilei. All rights reserved.
//

#import "AddPictureCell.h"

@implementation AddPictureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.picture = [[PictureView alloc] initWithFrame:CGRectMake(0, 6, self.width-6, self.height-6)];
        //self.picture.defatultImage = Image(@"add.png");
        self.picture.hasImage = NO;
        self.picture.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.picture];
        
        UIImage *image = Image(@"close.png");
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(self.width-25, 0, 25, 25);
        imageView.contentMode = UIViewContentModeTopRight;
        imageView.image = image;
        imageView.tag = 1001;
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        imageView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapCell:)])
    {
        [_delegate tapCell:self];
    }
}

- (void)showButton
{
    UIView *view = [self viewWithTag:1001];
    view.hidden = NO;
}

- (void)hiddenButton
{
    UIView *view = [self viewWithTag:1001];
    view.hidden = YES;
}
@end
