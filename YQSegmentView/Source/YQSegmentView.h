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
 * @param titlesArr item标题
 * @param handler item被选中时的回调
 */
+ (instancetype)segmentWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titlesArr handler:(void (^)(NSInteger idx, UIButton *item))handler;

/**
 * 初始化
 * @param titlesArr item标题
 * @param leftSpace 左边距
 * @param middleSpace item之间的间隔
 * @param rightSpace 右边距
 * @param handler item被选中时的回调
 */
+ (instancetype)segmentWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titlesArr leftSpace:(CGFloat)leftSpace middleSpace:(CGFloat)middleSpace rightSpace:(CGFloat)rightSpace handler:(void (^)(NSInteger idx, UIButton *item))handler;

- (void)setTitle:(NSString *)title atIndex:(NSUInteger)idx;
- (void)setTitleSelectedColor:(UIColor *)selColor unselectedColor:(UIColor *)unselColor;
- (void)setIndicateLineColor:(UIColor *)color;

- (void)selectIndex:(NSInteger)idx;
- (NSInteger)getSelectedIndex;

@end
