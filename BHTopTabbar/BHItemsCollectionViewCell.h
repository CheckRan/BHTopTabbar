//
//  BHItemsCollectionViewCell.h
//  ColeusHome
//
//  Created by qianfeng on 15/10/27.
//  Copyright © 2015年 BoHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHItemsCollectionViewCell : UICollectionViewCell

@property( nonatomic , copy ) NSString * nameTitle;

@property( nonatomic , copy ) void(^deleteButtonClickBlock)(void);

+(instancetype)itemsCollectionViewWithCollectioView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath;

-(void)openDeleteButton:(BOOL)open;

@end
