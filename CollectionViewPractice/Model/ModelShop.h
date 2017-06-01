//
//  ModelShop.h
//  CollectionViewPractice
//
//  Created by 武国斌 on 2017/6/1.
//  Copyright © 2017年 武国斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSJSONModel.h"

@interface ModelShop : CSJSONModel

@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *price;

@end
