//
//  CircleScrollView.h
//  ZDCircleScrollView
//
//  Created by 张海迪 on 14/12/6.
//  Copyright (c) 2014年 haidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, copy) NSArray *images;
@property (nonatomic) BOOL isTimer;
@property (nonatomic) BOOL isShowPageControl;
@end
