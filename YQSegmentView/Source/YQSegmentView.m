//
//  YQSegmentView.m
//  YQSegmentView
//
//  Created by 杨清 on 2018/9/26.
//  Copyright © 2018年 QuinceyYang. All rights reserved.
//

#import "YQSegmentView.h"

@interface YQSegmentView ()

@property (strong, nonatomic) UIScrollView *itemsScrollView;///<装多个标签的容器
@property (strong, nonatomic) NSMutableArray <UIButton *>*btnItemsArr;///<横排的多个按钮
@property (strong, nonatomic) UIView *indicateLine;///<短线（指示当前被选中的item）
@property (copy, nonatomic) void (^handler)(NSInteger idx, UIButton *item);
@end

@implementation YQSegmentView


+ (instancetype)segmentWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titlesArr handler:(void (^)(NSInteger idx, UIButton *item))handler
{
    YQSegmentView *segmentView = [[YQSegmentView alloc] initWithFrame:frame];
    UIScrollView *itemsScrollView = [[UIScrollView alloc] initWithFrame:segmentView.bounds];
    itemsScrollView.backgroundColor = UIColor.whiteColor;
    itemsScrollView.contentSize = CGSizeMake(itemsScrollView.frame.size.width, 0);
    itemsScrollView.showsVerticalScrollIndicator = NO;
    itemsScrollView.showsHorizontalScrollIndicator = NO;
    [segmentView addSubview:itemsScrollView];
    segmentView.itemsScrollView = itemsScrollView;
    segmentView.handler = handler;
    
    segmentView.btnItemsArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<titlesArr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30+i*(90+20), (itemsScrollView.frame.size.height-42)/2, 90, 42)];
        [btn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.grayColor forState:UIControlStateHighlighted];
        [btn setTitleColor:UIColor.orangeColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        btn.tag = i;
        [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
        [btn addTarget:segmentView action:@selector(tapBtnItems:) forControlEvents:UIControlEventTouchUpInside];
        [itemsScrollView addSubview:btn];
        [segmentView.btnItemsArr addObject:btn];
        //
        CGSize bestSize = [btn sizeThatFits:CGSizeMake(0, 0)];
        if (i==0) {
            btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y, bestSize.width, btn.frame.size.height);
        }
        else {
            btn.frame = CGRectMake(CGRectGetMaxX(segmentView.btnItemsArr[i-1].frame)+20, btn.frame.origin.y, bestSize.width, btn.frame.size.height);
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    itemsScrollView.contentSize = CGSizeMake(CGRectGetMaxX(segmentView.btnItemsArr.lastObject.frame)+30, 0);
    
    UIButton *selectedBtn = segmentView.btnItemsArr.firstObject;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(selectedBtn.frame.origin.x+0.1*selectedBtn.frame.size.width, CGRectGetMaxY(selectedBtn.frame), 0.8*selectedBtn.frame.size.width, 1.5)];
    line.backgroundColor = UIColor.orangeColor;
    [itemsScrollView addSubview:line];
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

#pragma mark - config style
- (void)setTitle:(NSString *)title atIndex:(NSUInteger)idx
{
    if (idx >= self.btnItemsArr.count) {
        return;
    }
    [self.btnItemsArr[idx] setTitle:title forState:UIControlStateNormal];
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
            btn.frame = CGRectMake(CGRectGetMaxX(_btnItemsArr[i-1].frame)+20, btn.frame.origin.y, bestSize.width, btn.frame.size.height);
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
    _itemsScrollView.contentSize = CGSizeMake(CGRectGetMaxX(_btnItemsArr.lastObject.frame)+30, 0);

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
    CGFloat visibleW = self.itemsScrollView.frame.size.width;
    CGFloat maxW = self.itemsScrollView.contentSize.width;
    CGFloat offsetX = sender.center.x - visibleW/2.0;
    if (maxW > visibleW) {
        if (offsetX >= 0 && maxW-offsetX>=visibleW) {
            [self.itemsScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        }
    }
    ////}
    if (self.handler) {
        self.handler(sender.tag, sender);
    }
}


@end
