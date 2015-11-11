//
//  BHSeparateCollectionViewCell.m
//  ColeusHome
//
//  Created by qianfeng on 15/10/27.
//  Copyright © 2015年 BoHe. All rights reserved.
//

#import "BHSeparateCollectionViewCell.h"

@implementation BHSeparateCollectionViewCell

+(instancetype)separateCollectionViewCellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseID = NSStringFromClass([self class]);
    
    [collectionView registerNib:[UINib nibWithNibName:reuseID  bundle:@"resource.bundle"] forCellWithReuseIdentifier:reuseID];
    return [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
