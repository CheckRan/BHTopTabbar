//
//  BHAddMoreItemsView.h
//  ColeusHome
//
//  Created by qianfeng on 15/10/27.
//  Copyright © 2015年 BoHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHAddMoreItemsView : UIView

@property( nonatomic , assign ) BOOL openDeleteButton;

+(instancetype)addMoreItemsViewWithNameArray:(NSArray *)array;

@property( nonatomic , strong ) NSMutableArray * modelArray;

@end
