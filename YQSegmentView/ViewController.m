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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *titlesArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<15; i++) {
        [titlesArr addObject:[NSString stringWithFormat:@"item%ld",i]];
    }
    YQSegmentView *segmentView = [YQSegmentView segmentWithFrame:CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, 60) titles:titlesArr handler:^(NSInteger idx, UIButton *item) {
        //
    }];
    [segmentView setTitle:@"[yqing]idx1" atIndex:1];
    [segmentView setTitleSelectedColor:UIColor.redColor unselectedColor:UIColor.grayColor];
    [segmentView setEnabledSeparateLine:YES];
    [self.view addSubview:segmentView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
