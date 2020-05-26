//
//  ShowPictureList.m
//  525JMobile
//
//  Created by iOS developer on 15/10/22.
//  Copyright (c) 2015年 song leilei. All rights reserved.
//

#import "ShowPictureList.h"
#import "PictureView.h"
#import "PhotoModel.h"
#import "ShowPictureController.h"

@interface ShowPictureList ()
<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate
>
@end

@implementation ShowPictureList
{
    UICollectionView *_collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:fl];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ShowPictureCell"];
    [self addSubview:_collectionView];
}

- (void)setPics:(NSArray *)pics
{
    _pics = pics;
    
    if (_pics && _pics.count > 0) {
        CGRect frame = _collectionView.frame;
        frame.size.height = 75;
        _collectionView.frame = frame;
    }

    [_collectionView reloadData];
}

#pragma mark -
#pragma mark UICollectionView DataSource Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _pics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ShowPictureCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                           forIndexPath:indexPath];
    PictureView *picture = [[PictureView alloc] initWithFrame:cell.bounds];
    picture.backgroundColor = BACKCOLOR(@"f2f2f2");
    picture.url = _pics[indexPath.row];
    [cell addSubview:picture];
    
    return cell;
}

#pragma mark -
#pragma mark UICollectionView Delegate Method
// 每一个cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75.0, 75.0);
}

// 设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

// cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

// cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

// cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShowPictureController *show = [[ShowPictureController alloc] init];

    NSMutableArray *models = [NSMutableArray array];
    for (NSString *url in _pics) {
        PhotoModel *model = [[PhotoModel alloc] init];
        model.image_HD = replaceString(url, SCREEN_WIDTH);
        [models addObject:model];
    }
    [show show:self.modalController type:Show isInternet:NO index:indexPath.row photoViews:models];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];
}

@end
