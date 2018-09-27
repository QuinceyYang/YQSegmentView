//
//  YQSegmentView.m
//  YQSegmentView
//
//  Created by 杨清 on 2018/9/26.
//  Copyright © 2018年 QuinceyYang. All rights reserved.
//

#import "YQSegmentView.h"

@interface YQSegmentView ()

@property (strong, nonatomic) UIScrollView *scrollView;///<装多个标签的容器
@property (strong, nonatomic) NSMutableArray <UIButton *>*btnItemsArr;///<横排的多个按钮
@property (strong, nonatomic) NSMutableArray <UIView *>*separateLineArr;///<竖分割线
@property (copy, nonatomic) void (^handler)(NSInteger idx, UIButton *item);

@property (assign, nonatomic) CGFloat leftSpace;
@property (assign, nonatomic) CGFloat middleSpace;
@property (assign, nonatomic) CGFloat rightSpace;

@end

@implementation YQSegmentView


+ (instancetype)segmentWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titlesArr handler:(void (^)(NSInteger idx, UIButton *item))handler
{
    YQSegmentView *segmentView = [[YQSegmentView alloc] initWithFrame:frame];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:segmentView.bounds];
    scrollView.backgroundColor = UIColor.whiteColor;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 0);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [segmentView addSubview:scrollView];
    segmentView.scrollView = scrollView;
    segmentView.handler = handler;
    
    segmentView.btnItemsArr = [[NSMutableArray alloc] init];
    segmentView.separateLineArr = [[NSMutableArray alloc] init];
    segmentView.leftSpace   = 30;
    segmentView.middleSpace = 20;
    segmentView.rightSpace  = 30;
    for (NSInteger i=0; i<titlesArr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(segmentView.leftSpace+i*(90+segmentView.middleSpace), (scrollView.frame.size.height-42)/2, 90, 42)];
        [btn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.grayColor forState:UIControlStateHighlighted];
        [btn setTitleColor:UIColor.orangeColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        btn.tag = i;
        [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
        [btn addTarget:segmentView action:@selector(tapBtnItems:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        [segmentView.btnItemsArr addObject:btn];
        //
        CGSize bestSize = [btn sizeThatFits:CGSizeMake(0, 0)];
        if (i==0) {
            btn.frame = CGRectMake(segmentView.leftSpace, btn.frame.origin.y, bestSize.width, btn.frame.size.height);
        }
        else {
            btn.frame = CGRectMake(CGRectGetMaxX(segmentView.btnItemsArr[i-1].frame)+segmentView.middleSpace, btn.frame.origin.y, bestSize.width, btn.frame.size.height);
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    scrollView.contentSize = CGSizeMake(CGRectGetMaxX(segmentView.btnItemsArr.lastObject.frame)+segmentView.rightSpace, 0);
    //
    if (scrollView.contentSize.width < segmentView.scrollView.frame.size.width) {
        scrollView.contentSize = CGSizeMake(segmentView.scrollView.frame.size.width, 0);
        segmentView.leftSpace = (scrollView.contentSize.width - (CGRectGetMaxX(segmentView.btnItemsArr.lastObject.frame)-segmentView.btnItemsArr.firstObject.frame.origin.x))/2;
        for (NSInteger i=0; i<segmentView.btnItemsArr.count; i++) {
            UIButton *btn = segmentView.btnItemsArr[i];
            if (i==0) {
                btn.frame = CGRectMake(segmentView.leftSpace, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
            }
            else {
                btn.frame = CGRectMake(CGRectGetMaxX(segmentView.btnItemsArr[i-1].frame)+segmentView.middleSpace, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
            }
        }
        scrollView.scrollEnabled = NO;
    }
    
    UIButton *selectedBtn = segmentView.btnItemsArr.firstObject;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(selectedBtn.frame.origin.x+0.1*selectedBtn.frame.size.width, CGRectGetMaxY(selectedBtn.frame), 0.8*selectedBtn.frame.size.width, 1.5)];
    line.backgroundColor = UIColor.orangeColor;
    [scrollView addSubview:line];
    segmentView.indicateLine = line;
    [segmentView tapBtnItems:selectedBtn];

    return segmentView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - setter getter
- (void)setEnabledSeparateLine:(BOOL)enabledSeparateLine
{
    _enabledSeparateLine = enabledSeparateLine;
    if (enabledSeparateLine) {
        //
        for (NSInteger i=0; i<_separateLineArr.count; i++) {
            [_separateLineArr[i] removeFromSuperview];
        }
        [_separateLineArr removeAllObjects];
        //
        for (NSInteger i=0; i<_btnItemsArr.count-1; i++) {
            UIButton *btn = _btnItemsArr[i];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+0.5*_middleSpace, btn.frame.origin.y+0.25*btn.frame.size.height, 1, 0.5*btn.frame.size.height)];
            line.backgroundColor = UIColor.greenColor;
            [_scrollView addSubview:line];
            [_separateLineArr addObject:line];
        }
    }
    else {
        for (NSInteger i=0; i<_separateLineArr.count; i++) {
            [_separateLineArr[i] removeFromSuperview];
        }
        [_separateLineArr removeAllObjects];
    }
}

#pragma mark - config style
- (void)setTitle:(NSString *)title atIndex:(NSUInteger)idx
{
    if (idx >= self.btnItemsArr.count) {
        return;
    }
    [self.btnItemsArr[idx] setTitle:title forState:UIControlStateNormal];
    if (self.scrollView.scrollEnabled) {
        //layout frames
        for (NSInteger i=0; i<_btnItemsArr.count; i++) {
            UIButton *btn = _btnItemsArr[i];
            UIFont *realFont = btn.titleLabel.font;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            CGSize bestSize = [btn sizeThatFits:CGSizeMake(0, 0)];
            if (i==0) {
                btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y, bestSize.width, btn.frame.size.height);
            }
            else {
                btn.frame = CGRectMake(CGRectGetMaxX(_btnItemsArr[i-1].frame)+_middleSpace, btn.frame.origin.y, bestSize.width, btn.frame.size.height);
            }
            btn.titleLabel.font = realFont;
        }
        //update indicate line
        for (NSInteger i=0; i<_btnItemsArr.count; i++) {
            if (_btnItemsArr[i].selected == YES) {
                UIButton *sender = _btnItemsArr[i];
                _indicateLine.frame = CGRectMake(sender.frame.origin.x+0.1*sender.frame.size.width, _indicateLine.frame.origin.y, sender.frame.size.width*0.8, _indicateLine.frame.size.height);
            }
        }
        //update content size
        _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(_btnItemsArr.lastObject.frame)+_rightSpace, 0);
        //update separate line
        [self setEnabledSeparateLine:_enabledSeparateLine];
    }
}

- (void)setTitleSelectedColor:(UIColor *)selColor unselectedColor:(UIColor *)unselColor
{
    for (UIButton *btn in self.btnItemsArr) {
        [btn setTitleColor:unselColor forState:UIControlStateNormal];
        [btn setTitleColor:unselColor forState:UIControlStateHighlighted];
        [btn setTitleColor:selColor forState:UIControlStateSelected];
    }
    self.indicateLine.backgroundColor = selColor;
}


#pragma mark - Actions
- (void)tapBtnItems:(UIButton *)sender
{
    //选择焦点效果
    for (NSInteger i=0; i<_btnItemsArr.count; i++) {
        if (sender == _btnItemsArr[i]) {
            sender.selected = YES;
            sender.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        }
        else {
            _btnItemsArr[i].selected = NO;
            _btnItemsArr[i].titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
    _indicateLine.frame = CGRectMake(sender.frame.origin.x+0.1*sender.frame.size.width, _indicateLine.frame.origin.y, sender.frame.size.width*0.8, _indicateLine.frame.size.height);

    ////{ 焦点居中
    if (self.scrollView.scrollEnabled) {
        CGFloat visibleW = self.scrollView.frame.size.width;
        CGFloat maxW = self.scrollView.contentSize.width;
        CGFloat offsetX = sender.center.x - visibleW/2.0;
        if (maxW > visibleW) {
            if (offsetX >= 0) {
                if (maxW-offsetX>=visibleW) {
                    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
                }
                else {
                    [self.scrollView setContentOffset:CGPointMake(maxW-visibleW, 0) animated:YES];
                }
            }
        }
    }
    ////}
    if (self.handler) {
        self.handler(sender.tag, sender);
    }
}


@end
