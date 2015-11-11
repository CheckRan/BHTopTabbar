//
//  BHItemsCollectionViewCell.m
//  ColeusHome
//
//  Created by qianfeng on 15/10/27.
//  Copyright © 2015年 BoHe. All rights reserved.
//

#import "BHItemsCollectionViewCell.h"

@interface BHItemsCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation BHItemsCollectionViewCell

+(instancetype)itemsCollectionViewWithCollectioView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseID = NSStringFromClass([self class]);
    
    [collectionView registerNib:[UINib nibWithNibName:reuseID  bundle:@"resource.bundle"] forCellWithReuseIdentifier:reuseID];
    return [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
}

-(void)setNameTitle:(NSString *)nameTitle
{
    _nameTitle = nameTitle;
    
    [self.titleButton setTitle:nameTitle forState:UIControlStateNormal];

}

-(void)openDeleteButton:(BOOL)open
{
    self.deleteButton.hidden = !open;
}

//点击删除按钮之后
- (IBAction)deleteButtonClick:(UIButton *)sender {

    if (self.deleteButtonClickBlock) {
        self.deleteButtonClickBlock();
    }
}

- (void)awakeFromNib {
    _deleteButton.layer.cornerRadius = 0.5 * _deleteButton.bounds.size.height;
    _deleteButton.clipsToBounds = YES;
    _titleButton.backgroundColor = [UIColor colorWithWhite:0.930 alpha:1.000] ;
    _deleteButton.hidden = YES;
}

@end
