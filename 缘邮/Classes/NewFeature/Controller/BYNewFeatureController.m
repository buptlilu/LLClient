//
//  BYNewFeatureController.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYNewFeatureController.h"
#import "BYNewFeatureCell.h"

@interface BYNewFeatureController ()

@property(nonatomic, weak)UIPageControl *control;

@end

@implementation BYNewFeatureController

static NSString * const reuseIdentifier = @"Cell";

-(instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置cell的尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    
    //清空行距
    layout.minimumLineSpacing = 0;
    
    //设置滚动方向为水平
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.collectionView registerClass:[BYNewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces =NO; //不允许弹性滑动，也就是去掉最左最右边图片滚动到没有图片的地方的效果
    self.collectionView.showsHorizontalScrollIndicator = NO; //去掉水平滚动条

    //添加pageController
    [self setUpPageControl];
}

-(void)setUpPageControl{
    //添加pageController，只需要设置位置，不需要管理尺寸
    UIPageControl *control = [[UIPageControl alloc] init];
    
    //设置页数和颜色
    control.numberOfPages = 5;
    control.pageIndicatorTintColor = [UIColor blackColor];
    control.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    //设置center
    control.center = CGPointMake(self.view.width * 0.5, self.view.height - 10);
    _control = control;
    [self.view addSubview:control];
}

#pragma mark - UIScrollView代理
//只要一滚动就会调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取当前的偏移量，计算当前第几页
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    
    //设置页数
    _control.currentPage = page;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BYNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //给cell传值
    NSString *imageName = [NSString stringWithFormat:@"new_feature_%ld", indexPath.row + 1];
    
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;

    if (screenH > 480) { //5, 6, 6plus
        imageName = [NSString stringWithFormat:@"new_feature_%ld_high", indexPath.row + 1];
    }
    
    cell.image = [UIImage imageNamed:imageName];

    [cell setIndexPath:indexPath count:5];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
