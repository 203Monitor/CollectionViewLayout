//
//  XMGWaterflowLayout.h
//  01-瀑布流
//
//  Created by xiaomage on 15/8/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterflowLayout;

@protocol WaterflowLayoutDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(WaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(WaterflowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(WaterflowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(WaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterflowLayout *)waterflowLayout;

@end

@interface WaterflowLayout : UICollectionViewLayout

/** 代理 */
@property (nonatomic, weak) id<WaterflowLayoutDelegate> delegate;

@end
