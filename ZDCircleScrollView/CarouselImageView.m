//
//  CircleScrollView.m
//  ZDCircleScrollView
//
//  Created by 张海迪 on 14/12/6.
//  Copyright (c) 2014年 haidi. All rights reserved.
//

#import "CarouselImageView.h"

@interface CarouselImageView ()<UIGestureRecognizerDelegate>
{
     NSTimer * scrollTimer;
    int scrollTopicFlag;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation CarouselImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, 18)]; // 初始化mypagecontrol
        _pageControl.center = CGPointMake(_scrollView.frame.size.width / 2.f, _scrollView.frame.size.height * 0.95);
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
        [_pageControl setPageIndicatorTintColor:[UIColor blackColor]];
         _pageControl.currentPage = 0;
        [_pageControl addTarget:self action:@selector(turnPage:) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
        [self addSubview:_pageControl];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseTimer) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFocusImage:)];
        [_scrollView addGestureRecognizer:tapGesture];

    }
    return self;
}
//图片数组
- (void)setImages:(NSArray *)images
{
    if (_images != images)
    {
        _images = images;
        _pageControl.numberOfPages = _images.count;
        [self initializeScrollViewImage];
    }
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
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    //   6-1-2-3-4-5-6-1
    
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(changeFocusImage) userInfo:nil repeats:YES];

}
#pragma mark - scrollView 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    CGFloat scrollWidth = _scrollView.frame.size.width;
    int page  = (scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width;
    _pageControl.currentPage = page;
    if (_scrollView.contentOffset.x <= 0)
    {
        //当scrollView的图片在第一个的时候
        [_scrollView setContentOffset:CGPointMake(scrollWidth * _images.count, 0) animated:NO];
    }
    else if(scrollView.contentOffset.x >= scrollWidth*(_images.count + 1))
    {
        //当scrollView的可见图片是最后一个时 设置可见rect在第二个
        [_scrollView setContentOffset:CGPointMake(scrollWidth, 0) animated:NO];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self startTimer];
}
#pragma mark -
- (void)changeFocusImage
{
    NSInteger page = _pageControl.currentPage; // 获取当前的page
    page++;
    page = page > _images.count ? 0 : page;
    [self turnPage:page];
}
- (void)turnPage:(NSInteger)page
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * (page + 1), 0) animated:YES];
}
- (void)pauseTimer
{
    if (scrollTimer)
    {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
}
- (void)startTimer
{
    [self pauseTimer];
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(changeFocusImage) userInfo:nil repeats:YES];
}
- (void)selectFocusImage:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:_scrollView];
    int index = (int)(point.x / self.frame.size.width);
    NSLog(@"点击了第%d张图片", index);
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedImageAtIndex:)])
    {
        [_delegate didSelectedImageAtIndex:index];
    }
}
@end
