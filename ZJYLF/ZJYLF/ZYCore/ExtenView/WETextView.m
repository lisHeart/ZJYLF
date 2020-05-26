//
//  WETextView.m
//  525JMobile
//
//  Created by liugaoyang on 16/1/11.
//  Copyright © 2016年 song leilei. All rights reserved.
//

#import "WETextView.h"

@implementation WETextView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textContainerInset = UIEdgeInsetsMake(5, 5, 20, 5);
        
        self.layer.borderColor = [SepartorLineColor CGColor];
        self.backgroundColor = BACKCOLOR(@"ffffff");
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
        self.textColor = DeepBlackTextColor;
        self.font = FontOfSize(FontSmallSize);
        self.delegate = self;
        
        [self initPlaceLabel];
        
        self.FontNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-155, self.frame.size.height-15, 150, 15)];
        self.FontNumLabel.enabled = NO;
        self.FontNumLabel.textAlignment = NSTextAlignmentRight;
        self.FontNumLabel.font = FontOfSize(FontSmallSize);
        self.FontNumLabel.textColor = LightGrayTextColor;
        [self addSubview:self.FontNumLabel];
        
        UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -30, SCREEN_WIDTH, 30)];
        [topView setBarStyle:UIBarStyleDefault];
        
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButton:)];
        
        NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, btnSpace, doneButton, nil];
        [topView setItems:buttonsArray];
        [self setInputAccessoryView:topView];
    }
    return self;
}

- (void)setNum:(int)Num {
    _Num = Num;
    self.FontNumLabel.text = [NSString stringWithFormat:@"0/%d", _Num];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    CGSize size = self.contentSize;
    if (size.height > self.FontNumLabel.top) {
        CGRect frame = self.FontNumLabel.frame;
        frame.origin.y = size.height + 5;
        self.FontNumLabel.frame = frame;
        self.contentSize = CGSizeMake(size.width-10, self.FontNumLabel.bottom);
    }
    
    self.FontNumLabel.text = [NSString stringWithFormat:@"%lu/%d", text.length, self.Num];
}

- (void)doneButton:(UIButton *)button {
    [self resignFirstResponder];
    if (self.Donedelegate && [self.Donedelegate respondsToSelector:@selector(InputDone:)]) {
        [self.Donedelegate InputDone:self.text];
    }
    if (self.Donedelegate && [self.Donedelegate respondsToSelector:@selector(InputDone:withCell:)]) {
        [self.Donedelegate InputDone:self.text withCell:self.cell];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView.text.length > self.Num) {
        NSString *lengthString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        textView.text = [lengthString substringToIndex:self.Num];

        ShowMessage([NSString stringWithFormat:@"您输入的内容不能超过%d个字",self.Num], nil);
        return NO;
    } else {
        if (textView.text.length == 0) {
            if ([text isEqualToString:@""]) {
                self.placeHolderLabel.hidden = NO;
            } else if(textView.text.length == 0){
                self.placeHolderLabel.hidden = NO;
            } else{
                self.placeHolderLabel.hidden = YES;
            }
        } else {
            self.placeHolderLabel.hidden = YES;
        }
        return YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.Donedelegate && [self.Donedelegate respondsToSelector:@selector(InputDone:withCell:)]) {
        [self.Donedelegate InputDone:textView.text withCell:self.cell];
    }
    
    if (self.Donedelegate && [self.Donedelegate respondsToSelector:@selector(InputDone:)]) {
        [self.Donedelegate InputDone:self.text];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        if (textView.text.length == 0){
            self.placeHolderLabel.hidden = NO;
        } else{
            self.placeHolderLabel.hidden = YES;
        }
    } else {
         self.placeHolderLabel.hidden = YES;
    }
    
    if (textView.text.length < self.Num+1) {
        self.FontNumLabel.text = [NSString stringWithFormat:@"%lu/%d",textView.text.length,self.Num];
    } else {
        textView.text = [textView.text substringToIndex:self.Num];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.Donedelegate&&[self.Donedelegate respondsToSelector:@selector(inputBeginWithCell:)]) {
        [self.Donedelegate inputBeginWithCell:self.cell];
    }
}

- (void)initPlaceLabel {
    self.placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 20)];
    self.placeHolderLabel.enabled = NO;
    self.placeHolderLabel.font = FontOfSize(FontSmallSize);
    self.placeHolderLabel.textColor = LightGrayTextColor;
    [self addSubview:self.placeHolderLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.contentSize;
    if (size.height > self.FontNumLabel.top) {
        CGRect frame = self.FontNumLabel.frame;
        frame.origin.y = size.height - 20;
        self.FontNumLabel.frame = frame;
        }

    
}
@end
