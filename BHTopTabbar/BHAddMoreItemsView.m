//
//  BHAddMoreItemsView.m
//  ColeusHome
//
//  Created by qianfeng on 15/10/27.
//  Copyright © 2015年 BoHe. All rights reserved.
//

#import "BHAddMoreItemsView.h"
#import "Masonry.h"
#import "BHItemsCollectionViewCell.h"
#import "BHSeparateCollectionViewCell.h"

@interface BHAddMoreItemsView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property( nonatomic , weak ) UICollectionView * collectionView;



@property( nonatomic , strong ) NSMutableArray * alertnationArray;

@end

@implementation BHAddMoreItemsView

+(instancetype)addMoreItemsViewWithNameArray:(NSArray *)array
{
    return [[self alloc]initWithArray:array];
}

-(instancetype)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        [self collectionView];
        //存在的 title
        _modelArray = [array mutableCopy];
        
        _alertnationArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MainBHAddMoreItemsView"] mutableCopy];
        
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void)setOpenDeleteButton:(BOOL)openDeleteButton
{
    _openDeleteButton = openDeleteButton;
    [self.collectionView reloadData];
}


-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 12;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView = collectionView;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
        //约束
        
        //        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionView"];
        __weak typeof(self) wself = self;
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wself.mas_top);
            make.left.equalTo(wself.mas_left);
            make.right.equalTo(wself.mas_right);
            make.bottom.equalTo(wself.mas_bottom);
        }];
//        _collectionView.frame = CGRectMake(0, 0, 10, 10);
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.modelArray.count;
    }
    else if(section == 1)
    {
        if (self.openDeleteButton) {
            return 0;
        }
        return self.alertnationArray.count ? 1 : 0;
    }
    else
    {
        if (self.openDeleteButton) {
            return  0;
        }
        return self.alertnationArray.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = nil;
    
    if (indexPath.section == 0 || indexPath.section == 2) {
        BHItemsCollectionViewCell * newCell = [BHItemsCollectionViewCell itemsCollectionViewWithCollectioView:collectionView andIndexPath:indexPath];
        cell = newCell;
        newCell.nameTitle = indexPath.section == 0 ? self.modelArray[indexPath.item] : self.alertnationArray[indexPath.item];
        [newCell openDeleteButton:_openDeleteButton];
        [newCell setDeleteButtonClickBlock:^{
            [_alertnationArray addObject:_modelArray[indexPath.item]];
            [_modelArray removeObjectAtIndex:indexPath.item];
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        }];
    }
    else
    {
        BHSeparateCollectionViewCell * newCell = [BHSeparateCollectionViewCell separateCollectionViewCellWithCollectionView:collectionView andIndexPath:indexPath];
        cell = newCell;
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return CGSizeMake(70, 35);
    }
    else if(indexPath.section == 1)
    {
        return CGSizeMake(self.bounds.size.width , 35);
    }
    else
    {
        return CGSizeMake(70, 35);
    }
}


-(void)dealloc
{
    NSLog(@"%s",__func__);
}


@end
