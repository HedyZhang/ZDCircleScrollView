//
//  ViewController.m
//  ZDCircleScrollView
//
//  Created by 张海迪 on 14/12/6.
//  Copyright (c) 2014年 haidi. All rights reserved.
//

#import "ViewController.h"
#import "CircleScrollView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *imagesArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i <= 6; i++)
    {
        [imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]]];
    }
    CircleScrollView *scrollView = [[CircleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.images = imagesArray;
    scrollView.isShowPageControl = YES;
    [self.view addSubview:scrollView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
