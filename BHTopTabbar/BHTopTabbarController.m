//
//  BHTopTabbarController.m
//  ColeusHome
//
//  Created by qianfeng on 15/10/24.
//  Copyright © 2015年 BoHe. All rights reserved.
//

#import "BHTopTabbarController.h"
#import "Masonry.h"
#import "BHAddMoreItemsView.h"

typedef NS_ENUM(NSUInteger, BHTopShowingStyle) {
    BHTopShowingStyleLeft,
    BHTopShowingStyleMiddle,
    BHTopShowingStyleRight,
};

@interface BHTopTabbarController ()<UIScrollViewDelegate>
/**
 *  添加控制器需要的 block
 */
@property( nonatomic , copy ) UIViewController * (^nextViewControllerCreatBlock)(NSInteger index);

@property( nonatomic , strong ) NSMutableArray * nameArray;

@property( nonatomic , strong ) NSMutableArray * currentShowArray;

@property( nonatomic , weak ) UIView * itemsView;

@property( nonatomic , strong ) NSMutableArray * itemsArray;

@property( nonatomic , weak ) UIButton * currentSelectedItem;

@property( nonatomic , weak ) BHAddMoreItemsView * addMoreItems;

@property( nonatomic , weak ) UIView * otherButtonView;

/**
 *  顶部滚动视图
 */
@property( nonatomic , weak ) UIScrollView * itemScrollView;

/**
 *  整体的滚动视图
 */
@property( nonatomic , weak ) UIScrollView * scrollView;
/**
 *  当前显示在 scrollerView 上的 viewControllers
 */
@property( nonatomic , strong ) NSMutableArray * currentShowViewControllers;

/**
 *  全部的 viewControllers
 */
@property( nonatomic , strong ) NSMutableDictionary * totalViewControllersDictonary;

/**
 *  显示的 viewControlelr
 */
@property( nonatomic , weak ) UIViewController * currentViewController;

@property( nonatomic , assign ) NSInteger currentIndex;
@property( nonatomic , assign ) NSInteger numberOfShowPage;
@property( nonatomic , assign ) int firstOpen;
@property( nonatomic , assign ) BHTopShowingStyle showingStyle;

@property( nonatomic , weak ) UIButton * addMoreButton;

@end

@implementation BHTopTabbarController

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

-(instancetype)initWithParentView:(UIViewController *)parentViewController itemsTitleArray:(NSArray *)titleArray NextViewContollerCreatBlock:(UIViewController *(^)(NSInteger))nextViewControllerCreatBlock
{
    if (self = [super init]) {
        self.nameArray = [titleArray mutableCopy];
        _numberOfShowPage = self.nameArray.count;
        _currentShowArray = [self.nameArray mutableCopy];
        
        _nextViewControllerCreatBlock = nextViewControllerCreatBlock;
        [parentViewController.view addSubview:self.view];
        [parentViewController addChildViewController:self];
        
        [self allocBasicView];
    }
    return self;
}

/**
 *  创建基本控件
 */
-(void)allocBasicView
{
    _itemSize = CGSizeMake(75, 44);
    _itemsArray = [NSMutableArray array];
    _currentShowViewControllers = [NSMutableArray array];
    _totalViewControllersDictonary = [NSMutableDictionary  dictionary];
    _currentIndex = 0;
    
    _nomalAttributedProperty = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor]};
    _selectedAttributedProperty = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRed:0.000 green:0.438 blue:0.000 alpha:1.000]};
    
    
    UIScrollView * scrolleView = [[UIScrollView alloc]init];
    _scrollView = scrolleView;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(3 * self.view.bounds.size.width , 0);
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIScrollView * itemsScrollView = [[UIScrollView alloc]init];
    _itemScrollView = itemsScrollView;
    _itemScrollView.bounces = NO;
    _itemScrollView.showsHorizontalScrollIndicator = NO;
    _itemScrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_itemScrollView];
    
    CGFloat height = 44;
    if (_hiddenAddMore) {
        height = 0;
    }
    
    [_itemScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@(44));
    }];
    
    UIButton * addMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addMoreButton .backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addMoreButton];
    _addMoreButton = addMoreButton;
    [_addMoreButton addTarget:self action:@selector(dealAddMoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_addMoreButton setImage:[UIImage imageNamed:@"Arrow.png"] forState:UIControlStateNormal];
    [_addMoreButton setImage:[UIImage imageNamed:@"Arrow.png"] forState:UIControlStateSelected];
    
    [_addMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemScrollView.mas_top);
        make.left.equalTo(_itemScrollView.mas_right);
        make.height.equalTo(_itemScrollView.mas_height);
        make.width.equalTo(@(height));
        make.right.equalTo(self.view.mas_right);
    }];
//    _itemScrollView.backgroundColor = [UIColor yellowColor];
    
    //创建 顶部的 Item 区域
    UIView * itemsView = [[UIView alloc]init];
    _itemsView = itemsView;
    
    [self.itemScrollView addSubview:_itemsView];
    UIView * lastView = nil;
    for (int i = 0 ; i < self.nameArray.count; i++ ) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.nameArray[i] forState:UIControlStateNormal];
        [self.itemsView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(0));
            make.left.equalTo(lastView ? lastView.mas_right : @(0));
            make.width.equalTo(@(_itemSize.width));
            make.height.equalTo(@(_itemSize.height));
        }];
//        button.backgroundColor = [UIColor orangeColor];
        
        [button addTarget:self action:@selector(dealButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //设置属性
        [button setAttributedTitle:[[NSAttributedString alloc] initWithString:self.nameArray[i] attributes:_nomalAttributedProperty] forState:UIControlStateNormal];
        [button setAttributedTitle:[[NSAttributedString alloc] initWithString:self.nameArray[i] attributes:_selectedAttributedProperty] forState:UIControlStateSelected];
        
        button.tag = i;
        [_itemsArray addObject:button];
        
        lastView = button;
    }
    //约束 ItemView
    [_itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.right.equalTo(lastView.mas_right);
        make.height.equalTo(lastView.mas_height);
    }];
    // 重设 _itemScrollView.contentSize
    [_itemScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_itemsView);
    }];
    
    
    //otherButtonView 及相关
    UIView * otherButtonView = [[UIView alloc]init];
    _otherButtonView = otherButtonView;
    [self.itemScrollView addSubview:_otherButtonView];
    [_otherButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemScrollView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.itemScrollView.mas_width);
        make.height.equalTo(self.itemScrollView.mas_height);
        
    }];
    _otherButtonView.backgroundColor  =[UIColor whiteColor];
    _otherButtonView.hidden = YES;
    
    //排序或删除
    UIButton * sortAndDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sortAndDeleteButton setAttributedTitle:[[NSAttributedString alloc]initWithString:@"排序或删除" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithRed:0.443 green:0.851 blue:0.702 alpha:1.000]}] forState:UIControlStateNormal];
    
    [sortAndDeleteButton setAttributedTitle:[[NSAttributedString alloc]initWithString:@"完成" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithRed:0.443 green:0.851 blue:0.702 alpha:1.000]}] forState:UIControlStateSelected];
    
    [sortAndDeleteButton addTarget:self action:@selector(dealSortAndDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.otherButtonView addSubview:sortAndDeleteButton];
    [sortAndDeleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_otherButtonView.mas_right).offset(-10);
        make.top.equalTo(_otherButtonView.mas_top);
        make.bottom.equalTo(_otherButtonView.mas_bottom);
    }];
    
    //切换频道
    UIButton * chooseModifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseModifyButton setAttributedTitle:[[NSAttributedString alloc]initWithString:@"切换频道" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithRed:0.459 green:0.447 blue:0.459 alpha:1.000]}] forState:UIControlStateNormal];
    [self.otherButtonView addSubview:chooseModifyButton];
    [chooseModifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_otherButtonView.mas_left).offset(10);
        make.top.equalTo(_otherButtonView.mas_top);
        make.bottom.equalTo(_otherButtonView.mas_bottom);
    }];
    [self refreshUI];
}

//点击排序或删除按钮之后
-(void)dealSortAndDeleteButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    _addMoreItems.openDeleteButton = button.selected;
}


//添加更多的
-(void)dealAddMoreButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    _otherButtonView.hidden = !button.selected;
    _itemsView.hidden = button.selected;
    [UIView animateWithDuration:0.25 animations:^{
        button.imageView.transform = CGAffineTransformRotate(button.imageView.transform, M_PI);
    }];
    
    if (!_addMoreItems) {
        BHAddMoreItemsView * addMoreItems = [BHAddMoreItemsView addMoreItemsViewWithNameArray:self.currentShowArray];
        _addMoreItems = addMoreItems;
        [self.view addSubview:_addMoreItems];
        [_addMoreItems mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.otherButtonView.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(49);
        }];
    }
    else
    {
        [_addMoreItems removeFromSuperview];
        _addMoreItems = nil;
    }
}

#pragma maek - Item 重新布局
-(void)itemReautoLayout
{
    UIView * lastView = nil;
    for (UIButton * button in _itemsArray) {
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(0));
            make.left.equalTo(lastView ? lastView.mas_right : @(0));
            make.width.equalTo(@(_itemSize.width));
            make.height.equalTo(@(_itemSize.height));
        }];
        lastView = button;
    }
    
    [_itemsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
}

//点击头部的 Item 处理事件
-(void)dealButtonClick:(UIButton *)button
{
    for (int i = 0 ; i < _itemsArray.count; i++ ) {
        UIButton * item = _itemsArray[i];
        if (item.tag == button.tag ) {
            self.currentIndex = i;
        }
    }

    [self refreshUI];
    
    if (self.showingStyle == BHTopShowingStyleLeft) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    else if(self.showingStyle == BHTopShowingStyleRight)
    {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width *  2, 0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ((self.scrollView.contentOffset.x > 1.5 * scrollView.bounds.size.width && _currentIndex < self.currentShowArray.count - 1) || (self.showingStyle == BHTopShowingStyleLeft && self.scrollView.contentOffset.x == scrollView.bounds.size.width)) {//向后滚动一个
        _currentIndex ++;
    }
    else if((self.scrollView.contentOffset.x < 0.5 * scrollView.bounds.size.width && _currentIndex > 0)|| (self.showingStyle == BHTopShowingStyleRight && self.scrollView.contentOffset.x == scrollView.bounds.size.width))//向前滚动一个
    {
        _currentIndex --;
    }
    else
    {
        return;
    }
    [self refreshUI];
    
}

-(void)setCurrentSelectedItem:(UIButton *)currentSelectedItem
{
    _currentSelectedItem.selected = NO;
    _currentSelectedItem = currentSelectedItem;
    _currentSelectedItem.selected = YES;
    
    CGRect frame = _currentSelectedItem.frame;
    [self.itemScrollView scrollRectToVisible:frame animated:YES];
}

//刷新 UI
-(void)refreshUI
{
    NSInteger from = 0;
    NSInteger to = 0;
    CGRect beginFrame = CGRectZero;
    
    //判断界限是否超出 Items 的范围
    if (self.currentIndex + 1 > _itemsArray.count - 1) {
        self.showingStyle = BHTopShowingStyleRight;
        to = 1;
        from = self.totalViewControllersDictonary[@([_itemsArray[self.currentIndex - 1] tag]).stringValue] ? 0 : 1;
        self.scrollView.contentOffset = CGPointMake( 2 * self.scrollView.bounds.size.width, 0);
        beginFrame = CGRectMake((2 - to + from) * self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    }
    if (self.currentIndex - 1 < 0) {
        self.showingStyle = BHTopShowingStyleLeft;
        from = 1;
        to = self.totalViewControllersDictonary[@([_itemsArray[self.currentIndex + 1] tag]).stringValue] ? 2 : 1;
        beginFrame = CGRectZero;
        self.scrollView.contentOffset = CGPointMake( 0 * self.scrollView.bounds.size.width, 0);
    }
    
    if (!to && !from) {
        self.showingStyle = BHTopShowingStyleMiddle;
        to = self.totalViewControllersDictonary[@([_itemsArray[self.currentIndex + 1] tag]).stringValue] ? 2 : 1;
        from = self.totalViewControllersDictonary[@([_itemsArray[self.currentIndex - 1] tag]).stringValue] ? 0 : 1;
        self.scrollView.contentOffset = CGPointMake(1 *  self.scrollView.bounds.size.width , 0);
        beginFrame = CGRectMake(from * self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    }
    
    [self clearChildViewController];
    [self clearCurentShowViewController];
    
    beginFrame.size.width = self.view.bounds.size.width;
    beginFrame.size.height = self.view.bounds.size.height;
    
    for (NSInteger i = from ; i <= to ; i++ ) {
        UIViewController * vc = [self findNeedViewController:[_itemsArray[self.currentIndex - 1 + i] tag]];
        [_currentShowViewControllers addObject:vc];

        [self.scrollView addSubview:vc.view];

        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_top).offset(108);
//            make.left.equalTo(lastView ? lastView.mas_right : @(0));
            make.left.equalTo(@(beginFrame.origin.x));
            make.width.equalTo(self.scrollView.mas_width);
            make.height.equalTo(self.scrollView.mas_height).offset(-108 -49);
        }];
        
        beginFrame.origin.x += beginFrame.size.width;
    }
    [self addChildViewController:[self findNeedViewController:[_itemsArray[self.currentIndex] tag]]];
    self.currentSelectedItem = _itemsArray[self.currentIndex];
    NSLog(@"childViewControllers : %@",self.childViewControllers);
}

-(void)clearCurentShowViewController
{
    for (UIViewController * vc in self.currentShowViewControllers) {
        [vc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        [vc.view removeFromSuperview];
        
    }
    [self clearChildViewController];
    [_currentShowViewControllers removeAllObjects];
}

-(void)clearChildViewController
{
    for (UIViewController * vc  in self.currentShowViewControllers) {
        [vc removeFromParentViewController];
    }
}


-(UIViewController *)findNeedViewController:(NSInteger)index
{
    UIButton * button = _itemsArray[index];
    if (!self.totalViewControllersDictonary[@(button.tag).stringValue]) {//字典中不存在
        if (self.nextViewControllerCreatBlock) {
            UIViewController * viewController = self.nextViewControllerCreatBlock(button.tag);
            self.totalViewControllersDictonary[@(button.tag).stringValue] = viewController;
            viewController.view.frame = self.view.frame;
        }
    }
    return self.totalViewControllersDictonary[@(button.tag).stringValue];
}

#pragma mark - 设置属性
-(void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    UIView * lastView = nil;
    for (UIButton * button in _itemsArray) {
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(_itemSize.width));
            make.height.equalTo(@(_itemSize.height));
        }];
        lastView = button;
    }
}

-(void)setHiddenAddMore:(BOOL)hiddenAddMore
{
    _hiddenAddMore = hiddenAddMore;
    if (_hiddenAddMore) {
        [_addMoreButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(0));
        }];
    }
    else
    {
        [_addMoreButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(44));
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
