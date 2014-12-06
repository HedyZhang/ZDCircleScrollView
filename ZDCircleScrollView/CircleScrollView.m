//
//  CircleScrollView.m
//  ZDCircleScrollView
//
//  Created by 张海迪 on 14/12/6.
//  Copyright (c) 2014年 haidi. All rights reserved.
//

#import "CircleScrollView.h"

@interface CircleScrollView ()
@end

@implementation CircleScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = self;
        self.pagingEnabled = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateTimer) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:UIApplicationWillEnterForegroundNotification object:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollPage) userInfo:nil repeats:YES];
   
    }
    return self;
}
//图片数组
- (void)setImages:(NSArray *)images
{
    _images = images;
    [self initializeScrollViewImage];
}
- (void)setIsShowPageControl:(BOOL)isShowPageControl
{
    if (isShowPageControl)
    {
        
    }
}
- (void)initializeScrollViewImage
{
    CGFloat scrollWidth = self.frame.size.width;
    CGFloat scrollHeight = self.frame.size.height;
    self.contentSize = CGSizeMake(scrollWidth * (_images.count + 2), scrollHeight);
    //图片加载到ScrollView中
    for (int i = 0; i < _images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, scrollHeight)];
        imageView.image = [_images objectAtIndex:i];
        imageView.frame = CGRectMake(scrollWidth * (i + 1), 0, scrollWidth, scrollHeight);
        [self addSubview:imageView];
    }
    //取最后一张图片放在ScrollView的第一个位置
    UIImageView *imageViewFirst = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, scrollHeight)];
    imageViewFirst.image = [_images objectAtIndex:_images.count - 1];
    [self addSubview:imageViewFirst];
    
    //取第一张图片放在ScrollView的最后位置
    UIImageView *imageViewLast = [[UIImageView alloc] initWithFrame:CGRectMake(_images.count * scrollWidth + scrollWidth, 0, scrollWidth, scrollHeight)];
    imageViewLast.image = [_images objectAtIndex:0];
    [self addSubview:imageViewLast];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollWidth = self.frame.size.width;
    CGFloat scrollHeight = self.frame.size.height;

    int currentPage = (int)self.contentOffset.x / scrollWidth;
    if (currentPage == 0)
    {
        //当scrollView的可见图片是第一个时 设置可见rect在倒数第二个
        [self scrollRectToVisible:CGRectMake(scrollWidth * _images.count , 0, scrollWidth, scrollHeight) animated:NO];
    }
    else if(currentPage == _images.count + 1)
    {
        //当scrollView的可见图片是最后一个时 设置可见rect在第二个
        [self scrollRectToVisible:CGRectMake(scrollWidth, 0, scrollWidth, scrollHeight) animated:NO];
    }
}
- (void)scrollPage
{
    
}
- (void)invalidateTimer
{
    
}
- (void)startTimer
{
    
}
@end
