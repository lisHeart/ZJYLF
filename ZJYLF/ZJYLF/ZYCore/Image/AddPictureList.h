//
//  AddPictureList.h
//  525JMobile
//
//  Created by iOS developer on 15/10/13.
//  Copyright (c) 2015年 song leilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddPictureListDelegate <NSObject>

- (void)tapPicture;

@end

/**
 footerview 点击事件代理
 */
@protocol footerDelegate <NSObject>

- (void)tapFoot;

@end

/** 
 headerView 输入框代理
 */
@protocol textHeaderDelegate<NSObject>

- (void)headerFieldWithContent:(NSString *)text;

@end
//@interface WEheader : UICollectionReusableView
//
//@end

@interface AddPictureList : UIView

@property (nonatomic, weak) id<AddPictureListDelegate> delegate;

@property (nonatomic, weak) id<footerDelegate> footerdelegate;

@property (nonatomic, weak) id<textHeaderDelegate> headerdelegate;

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, strong) NSArray *pics;

@property (nonatomic, strong) id modalController;
// 添加的图片数组
@property (nonatomic, strong) NSMutableArray *cellArrays;
// 是否有header和footer
@property (nonatomic, assign) BOOL isDirectionHorizontal;
// 是否可编辑 编辑就是纵向 不编辑就是横向
@property (nonatomic, assign) BOOL isCantEdit;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *adressLabel;
@end
