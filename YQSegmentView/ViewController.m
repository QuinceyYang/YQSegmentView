//
//  ViewController.m
//  YQSegmentView
//
//  Created by 杨清 on 2018/9/26.
//  Copyright © 2018年 QuinceyYang. All rights reserved.
//

#import "ViewController.h"
#import "YQSegmentView.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *hintLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *titlesArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<2; i++) {
        [titlesArr addObject:[NSString stringWithFormat:@"item%ld",i]];
    }
    __weak __typeof(self)weakSelf = self;
    YQSegmentView *segmentView = [YQSegmentView segmentWithFrame:CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, 60) titles:titlesArr leftSpace:100 middleSpace:80 rightSpace:100 handler:^(NSInteger idx, UIButton *item) {
        //
        weakSelf.hintLab.text = [NSString stringWithFormat:@"第%ld页",idx];
    }];
    //[segmentView setTitle:@"[yangqing]idx1" atIndex:1];
    [segmentView setTitleSelectedColor:UIColor.redColor unselectedColor:UIColor.grayColor];
    [segmentView setEnabledSeparateLine:YES];
    //[segmentView selectIndex:1];
    //[segmentView setIndicateLineColor:UIColor.clearColor];
    [self.view addSubview:segmentView];
    
    UILabel *hintLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentView.frame)+10, [UIScreen mainScreen].bounds.size.width, 300)];
    hintLab.textColor = UIColor.blackColor;
    hintLab.textAlignment = NSTextAlignmentCenter;
    hintLab.font = [UIFont systemFontOfSize:19];
    hintLab.text = [NSString stringWithFormat:@"第%ld页",[segmentView getSelectedIndex]];
    [self.view addSubview:hintLab];
    self.hintLab = hintLab;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
