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
/**
 * 设置item之间是否有分割线，
 * 当enabledSeparateLine=YES是，color为分割线颜色，当enabledSeparateLine=NO是，color无效
 */
- (void)setEnabledSeparateLine:(BOOL)enabledSeparateLine color:(UIColor *)color;

/**
 * 选中某个item，会回调hander（block）
 */
- (void)selectIndex:(NSInteger)idx;

/**
 * 选中某个item，不会回调hander（block）
 */
- (void)selectIndexUnCallBack:(NSInteger)idx;

- (NSInteger)getSelectedIndex;

@end
