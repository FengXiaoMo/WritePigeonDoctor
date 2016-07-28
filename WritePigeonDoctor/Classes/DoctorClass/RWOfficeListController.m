//
//  RWOfficeListController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWOfficeListController.h"

@interface RWOfficesCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation RWOfficesCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    
    return self;
}

@end

@interface RWOfficeListController ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong)UICollectionView *offices;
@property (nonatomic,strong)NSArray *officeList;

@end

@implementation RWOfficeListController

- (void)initViews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _offices = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                  collectionViewLayout:flowLayout];
    
    _offices.delegate = self;
    _offices.dataSource = self;
    
    _offices.showsVerticalScrollIndicator = NO;
    _offices.showsHorizontalScrollIndicator = NO;
    
    [_offices registerClass:[RWOfficesCell class] forCellWithReuseIdentifier:NSStringFromClass([RWOfficesCell class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _officeList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWOfficesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWOfficesCell class]) forIndexPath:indexPath];
    
    cell.imageView.image = _officeList[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width/4, collectionView.bounds.size.width/4);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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