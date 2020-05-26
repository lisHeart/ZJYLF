//
//  ShowPictureList.h
//  525JMobile
//
//  Created by iOS developer on 15/10/22.
//  Copyright (c) 2015年 song leilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowPictureListDelegate <NSObject>

- (void)tapPicture:(NSInteger)index;

@end

@interface ShowPictureList : UIView

@property (nonatomic, weak) id<ShowPictureListDelegate> delegate;

@property (nonatomic, strong) NSArray *pics;

@property (nonatomic, strong) id modalController;

@end
