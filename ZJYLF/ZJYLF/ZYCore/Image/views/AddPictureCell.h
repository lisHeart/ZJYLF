//
//  AddPictureCell.h
//  525JMobile
//
//  Created by iOS developer on 15/10/14.
//  Copyright (c) 2015年 song leilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureView.h"

@class AddPictureCell;
@protocol AddPictureCellDelegate <NSObject>

- (void)tapCell:(AddPictureCell *)cell;

@end

@interface AddPictureCell : UICollectionViewCell

@property (nonatomic, weak) id<AddPictureCellDelegate> delegate;

@property (nonatomic, strong) PictureView *picture;

- (void)showButton;

- (void)hiddenButton;
@end
