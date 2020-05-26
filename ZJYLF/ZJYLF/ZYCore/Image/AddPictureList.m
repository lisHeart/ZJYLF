//
//  AddPictureList.m
//  525JMobile
//
//  Created by iOS developer on 15/10/13.
//  Copyright (c) 2015年 song leilei. All rights reserved.
//

#import "AddPictureList.h"
#import "AddPictureCell.h"
#import "PhotoModel.h"
#import "ShowPictureController.h"
#import "WETextView.h"


@interface AddPictureList ()
<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UIActionSheetDelegate,
AddPictureCellDelegate,
ShowPictureControllerDelegate,
TextFieldDoneDelegate>
@end
static NSString *HeaderID = @"header";
static NSString *FooterID = @"footer";
@implementation AddPictureList

{
    AddPictureCell *selectCell;
    UIView *pictureView;//headView
}
//- (instancetype)init {
//    self = [super init];
//    if (self)
//    {
//        [self addObserver:self forKeyPath:@"maxCount" options:NSKeyValueObservingOptionNew context:nil];
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addObserver:self forKeyPath:@"maxCount" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"maxCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"maxCount"]) {
        [self initUI];
    }
}

- (void)initUI
{
    if (!self.cellArrays) {
        self.cellArrays = [NSMutableArray array];
        [self.cellArrays addObject:@"1"];
    }
   
    
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    if (_isCantEdit) {
        fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:fl];
    [_collectionView registerClass:[AddPictureCell class] forCellWithReuseIdentifier:@"Add Picture Cell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = BACKCOLOR(@"ffffff");
    
    // 注册头部
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderID];
    // 如果有class来注册这个头部或尾部视图时一定要用代码的方式去设置下这个头部或尾部的尺寸
    // 加载的时候会根据字符串来判断是头还是尾
    
    
    
    // 注册尾部
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterID];
    
    
    if (_isDirectionHorizontal) {
        
        //上传图片背景
        pictureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225)];
        pictureView.backgroundColor = TEXTCOLOR(@"ffffff");
        
        WETextView * _textView=[[WETextView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 180)];
        _textView.placeHolderLabel.text=@"跟进记录不能少于5个字（必填）";
        _textView.Donedelegate=self;
        _textView.backgroundColor=TEXTCOLOR(@"ffffff");
        _textView.Num=120;
        [pictureView addSubview:_textView];
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, _textView.bottom, SCREEN_WIDTH, 10)];
        sepView.backgroundColor = ViewBackGroundColor;
        [pictureView addSubview:sepView];
        
        //图片标题
        UILabel *pictLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 200, 15)];
        pictLab.textColor = LightGrayTextColor;
        pictLab.font = FontOfSize(FontNormalSize);
        [pictureView addSubview:pictLab];
        NSString *Str =@"上传图片(非必填)";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:Str];
        [attrString addAttribute:NSForegroundColorAttributeName value:DeepBlackTextColor range:NSMakeRange(0,4)];
        [attrString addAttribute:NSForegroundColorAttributeName value:LightGrayTextColor range:NSMakeRange(4,5)];
        [pictLab setAttributedText:attrString];
        fl.headerReferenceSize = CGSizeMake(50, 215);
        fl.footerReferenceSize = CGSizeMake(50, 45);
        
        //footer
        self.adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 15, SCREEN_WIDTH-36, 15)];
      
    }else {
        fl.headerReferenceSize = CGSizeMake(0, 0);
        fl.footerReferenceSize = CGSizeMake(0, 0);
    }
    [self addSubview:_collectionView];
}
- (void) setCellArrays:(NSMutableArray *)cellArrays {
    _cellArrays = cellArrays;
    self.collectionView.frame = self.bounds;
    [self.collectionView reloadData];
}
#pragma mark -
#pragma mark UICollectionView DataSource Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _cellArrays.count > _maxCount ? _maxCount : _cellArrays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddPictureCell *cell = (AddPictureCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Add Picture Cell"
                                                                                       forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = 8080 + indexPath.row;
    
    if ([_cellArrays[indexPath.row] isKindOfClass:[NSString class]]) {
        if ([_cellArrays[indexPath.row] isEqualToString:@"1"]) {
            cell.picture.hasImage = NO;
            cell.picture.defatultImage = Image(@"add.png");
            [cell hiddenButton];
        }else {
            cell.picture.url = _cellArrays[indexPath.row];
            cell.picture.hasImage = YES;
            cell.picture.isNotShow = YES;
            [cell hiddenButton];
        }
       
    } else {
        cell.picture.hasImage = YES;
        cell.picture.image = _cellArrays[indexPath.row];
        [cell showButton];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UICollectionView Delegate Method
// 每一个cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 0.0;
    if (iPhone5)
        width = 65.0;
    else
        width = 80.0;
    return CGSizeMake(width, width);
}

// 设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

// cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

// cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

// cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddPictureCell *cell = (AddPictureCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    selectCell = cell;
    
    if ([_cellArrays[indexPath.row] isKindOfClass:[NSString class]]) {
        if ([_cellArrays[indexPath.row] isEqualToString:@"1"]) {
            UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"拍照", @"从相册中选择", nil];
            [aSheet showInView:((UIViewController *)self.modalController).view];
        }else{
            ShowPictureController *show = [[ShowPictureController alloc] init];
            show.delegate = self;
            
            NSMutableArray *models = [NSMutableArray array];
            for (id obj in _cellArrays) {
                    PhotoModel *model = [[PhotoModel alloc] init];
                    model.image_HD = obj ;
                    [models addObject:model];
            }
            
            [show show:self.modalController type:Show isInternet:NO index:indexPath.row photoViews:models];
            [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];
        }
      
        
    } else {
        
        ShowPictureController *show = [[ShowPictureController alloc] init];
        show.delegate = self;
        
        NSMutableArray *models = [NSMutableArray array];
        for (id obj in _cellArrays) {
            if (![obj isKindOfClass:[NSString class]]) {
                PhotoModel *model = [[PhotoModel alloc] init];
                model.fullScreenImage = obj;
                [models addObject:model];
            }
        }
        
        [show show:self.modalController type:Show isInternet:NO index:indexPath.row photoViews:models];
        [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];
    }
}
// 返回每一组的头部或尾部视图
// 会自动的在每一组的头部和尾部加上这个视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    // 如果当前想要的是头部视图
    // UICollectionElementKindSectionHeader是一个const修饰的字符串常量,所以可以直接使用==比较
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderID forIndexPath:indexPath];
        [headerView addSubview:pictureView];
        return headerView;
    } else { // 返回每一组的尾部视图
        UICollectionReusableView *footerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterID forIndexPath:indexPath];
        
        footerView.backgroundColor = TEXTCOLOR(@"ffffff");
        footerView.userInteractionEnabled = YES;
        footerView.size = CGSizeMake(SCREEN_WIDTH, 45);
        
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 16, 16)];
        headView.image = Image(@"Amount_map");
        [footerView addSubview:headView];
        if (isBlankString(self.adressLabel.text)) {
            self.adressLabel.text = @"获取地理位置";
        }
        self.adressLabel.textColor = ContentTextColor;
        self.adressLabel.font = FontOfSize(FontNormalSize);
        [footerView addSubview:self.adressLabel];
        
        [UIView viewLinePoint:CGPointMake(10, 0) inView:footerView length:SCREEN_WIDTH-10 andAngle:0 lineColor:SepartorLineColor lineWidth:1];
        [UIView viewLinePoint:CGPointMake(0, 43) inView:footerView length:SCREEN_WIDTH andAngle:0 lineColor:SepartorLineColor lineWidth:1];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(footerTap) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:button];
        
        return footerView;
    }
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // Take picture
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                // 此处设置只能使用相机，禁止使用视频功能
                picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
                picker.allowsEditing = NO;
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:picker animated:YES completion:nil];
            }
            break;
        case 1: // From album
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.allowsEditing = NO;
                picker.delegate = self;
                [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:picker animated:YES completion:nil];
            }
            break;
        case 2:
            
            break ;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        //获取照片的原图
        UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
        original = [original fixOrientation:original];
        
        //获取图片裁剪的图
//        UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
        //获取图片的路径
//        NSURL* filePath = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        NSInteger index = selectCell.tag - 8080;
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.cellArrays replaceObjectAtIndex:index withObject:original];
        if (self.cellArrays.count < _maxCount)
            [self.cellArrays addObject:@"1"];
        
        [_collectionView reloadData];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
            [self saveImageToPhoto:original];
    }
}

- (void)saveImageToPhoto:(UIImage *)saveImage
{
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil;
    if (error != NULL)
        msg = @"保存图片失败";
    else
        msg = @"保存照片成功";
    

}

#pragma mark -
#pragma mark AddPicutreCell Delegate Method

- (void)tapCell:(AddPictureCell *)cell
{
    NSInteger index = cell.tag - 8080;
    if (self.cellArrays.count == _maxCount) {
        [self.cellArrays removeObjectAtIndex:index];
        [self.cellArrays addObject:@"1"];
    } else {
        [self.cellArrays removeObjectAtIndex:index];
    }
    
    [_collectionView reloadData];
}

#pragma mark - foot 点击
- (void) footerTap {
    if (self.footerdelegate && [self.footerdelegate respondsToSelector:@selector(tapFoot)]) {
        [self.footerdelegate tapFoot];
    }
}

#pragma mark - header  输入
-(void)InputDone:(NSString *)textViewText {
    if (self.headerdelegate && [self.headerdelegate respondsToSelector:@selector(headerFieldWithContent:)]) {
        [self.headerdelegate headerFieldWithContent:textViewText];
    }
}
@end
