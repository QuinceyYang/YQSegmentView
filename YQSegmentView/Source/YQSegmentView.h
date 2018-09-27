//
//  YQSegmentView.h
//  YQSegmentView
//
//  Created by 杨清 on 2018/9/26.
//  Copyright © 2018年 QuinceyYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQSegmentView : UIView

@property (strong, nonatomic) UIView *indicateLine;///<短线（指示当前被选中的item）
@property (assign, nonatomic) BOOL enabledSeparateLine;///<是否使能竖分割线

/**
 * 初始化
 */
+ (instancetype)segmentWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titlesArr handler:(void (^)(NSInteger idx, UIButton *item))handler;

- (void)setTitle:(NSString *)title atIndex:(NSUInteger)idx;
- (void)setTitleSelectedColor:(UIColor *)selColor unselectedColor:(UIColor *)unselColor;

@end
