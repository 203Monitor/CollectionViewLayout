//
//  ViewController.m
//  CollectionViewPractice
//
//  Created by 武国斌 on 2017/6/1.
//  Copyright © 2017年 武国斌. All rights reserved.
//

#import "ViewController.h"
#import "ModelShop.h"
#import "ShopCell.h"
#import "WaterflowLayout.h"
#import "MJRefresh.h"

static NSString *const cellId = @"CELLID";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WaterflowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WaterflowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRefresh];
}

- (void)setupRefresh {
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.mj_footer.hidden = YES;
}

- (void)loadNewShops {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *datas = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Datas" ofType:@"plist"]];
        NSArray *shops = [ModelShop arrayOfModelsFromDictionaries:datas error:nil];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:shops];
        // 刷新数据
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    });
}

- (void)loadMoreShops {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *datas = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Datas" ofType:@"plist"]];
        NSArray *shops = [ModelShop arrayOfModelsFromDictionaries:datas error:nil];
        [self.dataSource addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
    });
}

#pragma mark - layout初始化
- (WaterflowLayout *)layout {
    if (!_layout) {
        // 创建布局
        _layout = [[WaterflowLayout alloc] init];
        _layout.delegate = self;
    }
    return _layout;
}

#pragma mark - collectionView初始化
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        [_collectionView setBackgroundColor:[UIColor cyanColor]];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        
        // 注册cell、sectionHeader、sectionFooter
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCell class]) bundle:nil] forCellWithReuseIdentifier:cellId];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - 数据源初始化
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark ---- UICollectionViewDataSource

#pragma mark - section数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - section数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.mj_footer.hidden = self.dataSource.count == 0;
    return self.dataSource.count;
}

#pragma mark - cellForItemAtIndexPath
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell setShop:self.dataSource[indexPath.item]];
    return cell;
}

#pragma mark - 和UITableView类似，UICollectionView也可设置header/footerView，配合header/footerView大小
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
//        if(headerView == nil) {
//            headerView = [[UICollectionReusableView alloc] init];
//        }
//        headerView.backgroundColor = [UIColor redColor];
//        return headerView;
//    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        UICollectionReusableView *footerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
//        if(footerView == nil) {
//            footerView = [[UICollectionReusableView alloc] init];
//        }
//        footerView.backgroundColor = [UIColor blackColor];
//        return footerView;
//    }
//    return nil;
//}

#pragma mark - <XMGWaterflowLayoutDelegate>
//返回每个cell的高度
- (CGFloat)waterflowLayout:(WaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    ModelShop *shop = self.dataSource[index];
    return itemWidth * shop.h / shop.w;
}

//每行的最小距离
- (CGFloat)rowMarginInWaterflowLayout:(WaterflowLayout *)waterflowLayout {
    return 10;
}
//有多少列
- (CGFloat)columnCountInWaterflowLayout:(WaterflowLayout *)waterflowLayout {
//    if (self.shops.count <= 50) return 2;
//    return 3;
    return 2;
}

//内边距
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterflowLayout *)waterflowLayout {
    return UIEdgeInsetsMake(10, 20, 30, 10);
}

/*
 
#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return (CGSize){SCALE(100),SCALE(100)};
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10.f;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 5.f;
//}

#pragma mark - 设置headerView大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
//    return (CGSize){kScreenWidth,44};
}

#pragma mark - 设置footerView大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
//    return (CGSize){kScreenWidth,22};
}

*/

#pragma mark ---- UICollectionViewDelegate

#pragma mark - （长按）item进入高亮状态
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

#pragma mark - （长按）item取消高亮状态
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - 是否select点击的item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    if (cell.titleLabel.textColor == [UIColor blackColor]) {
//        [cell.titleLabel setTextColor:[UIColor redColor]];
//        return NO;
//    }else {
//        [cell.titleLabel setTextColor:[UIColor blackColor]];
//        return YES;
//    }
    return YES;
}

#pragma mark - 是否deselect点击的item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    if (cell.titleLabel.textColor == [UIColor redColor]) {
//        [cell.titleLabel setTextColor:[UIColor blackColor]];
//        return YES;
//    }else {
//        [cell.titleLabel setTextColor:[UIColor redColor]];
//        return NO;
//    }
    return YES;
}

#pragma mark - didSelectItemAtIndexPath
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"tapped %ld",(long)indexPath.item);
}

#pragma mark - didDeselectItemAtIndexPath
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"deselected %ld",indexPath.item);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
