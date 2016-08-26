//
//  DYUHomeViewController.m
//  DYVideoTools
//
//  Created by qiyun on 16/8/25.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import "DYUHomeViewController.h"


@interface DYUHomeViewController ()

<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView  *imageCollectionView;

@end

@implementation DYUHomeViewController


#pragma mark    -   life cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.imageCollectionView];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark    -   get/set method

- (UICollectionView *)imageCollectionView{
    
    if (!_imageCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_imageCollectionView registerNib:[UINib nibWithNibName:@"DYUHomeCollectionCell"
                                                    bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"cellId"];
        
        [_imageCollectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"reusableView"];
        
        _imageCollectionView.delegate    = self;
        _imageCollectionView.dataSource  = self;
        _imageCollectionView.bounces     = NO;
        _imageCollectionView.backgroundColor = [UIColor clearColor];
    }
    return _imageCollectionView;
}


#pragma mark    -   UICollectionView    delegate

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    NSLog(@"~~~%@  tag = %ld",indexPath,indexPath.section * [collectionView numberOfItemsInSection:indexPath.section] + indexPath.row);
    
    UIImageView *imageView = [cell viewWithTag:1];
    imageView.image = [UIImage imageNamed:@"01.png"];
    
    NSString *string = [@"图片序号：" stringByAppendingFormat:@"%ld",indexPath.section * [collectionView numberOfItemsInSection:indexPath.section] + indexPath.row];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}
                        range:NSMakeRange(5, [string length] - 5)];
    
    UILabel *title = [cell viewWithTag:2];
    title.attributedText = attrString;
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH * 0.3, SCREEN_WIDTH * 0.3);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//定义每个UICollectionView之前的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return (SCREEN_WIDTH * 0.1)/4;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.section * [collectionView numberOfItemsInSection:indexPath.section] + indexPath.row;
    NSLog(@"点击第%ld张图片",(long)index);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
