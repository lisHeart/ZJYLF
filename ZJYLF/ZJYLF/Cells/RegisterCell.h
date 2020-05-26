//
//  RegisterCell.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/21.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cellTextFieldDelegete <NSObject>

- (void) getTextFieldDoneContent:(NSString *)str andCell:(id)cell;

@end

@interface RegisterCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, strong)UILabel *titLabel;
@property (nonatomic, strong)UIImageView *headView;
@property (nonatomic, strong)UITextField *input;
@property (nonatomic, assign)id<cellTextFieldDelegete> cellDelegate;
@end
