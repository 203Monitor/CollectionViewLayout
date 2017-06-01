//
//  UIView+AutoLayout.h
//  CollectionViewPractice
//
//  Created by 武国斌 on 2017/6/1.
//  Copyright © 2017年 武国斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)

/**
 自动适配所有子视图
 */
- (void)autoLayoutAllSubviews;

/**
 控件能否设置文字

 @return 能否设置文字
 */
- (BOOL)canSetText;

@end
