//
//  CircleScrollView.m
//  ZDCircleScrollView
//
//  Created by 张海迪 on 14/12/6.
//  Copyright (c) 2014年 haidi. All rights reserved.
//

#import "CircleScrollView.h"

@interface CircleScrollView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation CircleScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
   
    }
    return self;
}
//图片数组
- (void)setImages:(NSArray *)images
{
    _images = images;
    
    [self initializeScrollViewImage];
}
- (void)initializeScrollViewImage
{
    CGFloat scrollWidth = _scrollView.frame.size.width;
    CGFloat scrollHeight = _scrollView.frame.size.height;
    _scrollView.contentSize = CGSizeMake(scrollWidth * (_images.count + 2), scrollHeight);
    //图片加载到ScrollView中
    for (int i = 0; i < _images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, scrollHeight)];
        imageView.image = [_images objectAtIndex:i];
        imageView.frame = CGRectMake(scrollWidth * (i + 1), 0, scrollWidth, scrollHeight);
        [_scrollView addSubview:imageView];
    }
    //取最后一张图片放在ScrollView的第一个位置
    UIImageView *imageViewFirst = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, scrollHeight)];
    imageViewFirst.image = [_images objectAtIndex:_images.count - 1];
    [_scrollView addSubview:imageViewFirst];
    
    //取第一张图片放在ScrollView的最后位置
    UIImageView *imageViewLast = [[UIImageView alloc] initWithFrame:CGRectMake(_images.count * scrollWidth + scrollWidth, 0, scrollWidth, scrollHeight)];
    imageViewLast.image = [_images objectAtIndex:0];
    [_scrollView addSubview:imageViewLast];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollWidth = _scrollView.frame.size.width;
    CGFloat scrollHeight = _scrollView.frame.size.height;

    int currentPage = (int)_scrollView.contentOffset.x / scrollWidth;
    if (currentPage == 0)
    {
        //当scrollView的可见图片是第一个时 设置可见rect在倒数第二个
        [_scrollView scrollRectToVisible:CGRectMake(scrollWidth * _images.count , 0, scrollWidth, scrollHeight) animated:NO];
    }
    else if(currentPage == _images.count + 1)
    {
        //当scrollView的可见图片是最后一个时 设置可见rect在第二个
        [_scrollView scrollRectToVisible:CGRectMake(scrollWidth, 0, scrollWidth, scrollHeight) animated:NO];
    }
}
@end
