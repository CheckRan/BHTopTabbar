//
//  BHTopTabbarController.h
//  ColeusHome
//
//  Created by qianfeng on 15/10/24.
//  Copyright © 2015年 BoHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHTopTabbarController : UIViewController

#pragma make - Item 的属性
@property( nonatomic , assign ) CGSize itemSize;
@property( nonatomic , copy ) NSDictionary * selectedAttributedProperty;
@property( nonatomic , copy ) NSDictionary * nomalAttributedProperty;
@property( nonatomic , strong ) UIImage * selectedBackgroundImage;
@property( nonatomic , strong ) UIImage * nomalBackgroundImage;

/**
 *添加更多是否隐藏
 */
@property( nonatomic , assign ) BOOL hiddenAddMore;

-(instancetype)initWithParentView:(UIViewController *)parentViewController
                  itemsTitleArray:(NSArray *)titleArray
      NextViewContollerCreatBlock:(UIViewController *(^)(NSInteger))nextViewControllerCreatBlock;
@end
