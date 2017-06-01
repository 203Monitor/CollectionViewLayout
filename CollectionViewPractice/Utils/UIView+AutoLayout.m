//
//  UIView+AutoLayout.m
//  CollectionViewPractice
//
//  Created by 武国斌 on 2017/6/1.
//  Copyright © 2017年 武国斌. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (void)autoLayoutAllSubviews {
    [self autoLayout];
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[UIView class]]) {
            [subview autoLayoutAllSubviews];
        } else {
            [subview autoLayout];
        }
    }
}

/**
 *  autolayout
 */
- (void)autoLayout {
    self.frame = CGRectMake(ceil(SCALE(self.frame.origin.x)), ceil(SCALE(self.frame.origin.y)), ceil(SCALE(self.frame.size.width)), ceil(SCALE(self.frame.size.height)));
    [self setFontLayout];
}

- (void)setFontLayout {
    if ([self canSetText]) {
        UILabel *label = (UILabel *)self;
        [label setFont:[UIFont systemFontOfSize:label.font.pointSize]];
    } else if ([self isButton]) {
        UILabel *label = [(UIButton *)self titleLabel];
        [label setFont:[UIFont systemFontOfSize:label.font.pointSize]];
    }
}

- (BOOL)isButton {
    return [self isKindOfClass:[UIButton class]];
}

- (BOOL)canSetText {
    return [self respondsToSelector:@selector(setText:)];
}

@end
