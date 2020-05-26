//
//  WETextView.h
//  525JMobile
//
//  Created by liugaoyang on 16/1/11.
//  Copyright © 2016年 song leilei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WEAddAppointTableViewCell;
@protocol TextFieldDoneDelegate <NSObject>
@optional
-(void)InputDone:(NSString *)textViewText;
-(void)InputDone:(NSString *)textViewText withCell:(id)cell;
- (void)inputBeginWithCell:(id)cell ;
@end

@interface WETextView : UITextView <UITextViewDelegate>
@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)UILabel *FontNumLabel;
@property(nonatomic,assign)int Num;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,assign)id<TextFieldDoneDelegate>Donedelegate;
@property(nonatomic,strong)WEAddAppointTableViewCell *cell;
@end
