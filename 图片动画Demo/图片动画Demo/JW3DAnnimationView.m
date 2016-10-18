//
//  JW3DAnnimationView.m
//  图片动画Demo
//
//  Created by canoe on 2016/10/17.
//  Copyright © 2016年 轻舟. All rights reserved.
//

#import "JW3DAnnimationView.h"

@interface JW3DAnnimationView ()<UIGestureRecognizerDelegate>

@property (nonatomic ,strong) NSTimer * timer;
@property (nonatomic ,assign)  int currentIndex;

@property (nonatomic ,strong) UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic ,strong) UISwipeGestureRecognizer *rightSwipe;

@end

@implementation JW3DAnnimationView

-(void)setJw_animationState:(JW3DAnnimationViewState)jw_animationState
{
    _jw_animationState = jw_animationState;
}

-(void)setJw_animationImages:(NSArray<UIImage *> *)jw_animationImages
{
    _jw_animationImages = jw_animationImages;
    self.image = jw_animationImages[0];
    self.currentIndex = 0;
}

-(void)setJw_animationDuration:(NSTimeInterval)jw_animationDuration
{
    _jw_animationDuration = jw_animationDuration;
}

-(void)jw_startAnimating
{
    self.jw_animating = YES;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.jw_animationDuration/self.jw_animationImages.count target:self selector:@selector(showNextImage:) userInfo:nil repeats:YES];
    }else
    {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

-(void)jw_stopAnimating
{
    self.jw_animating = NO;
    [self.timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - 定时器调用换下一张图片
-(void)showNextImage:(NSTimer *)timer
{
    switch (self.jw_animationState) {
        case JW3DAnnimationViewStateAscending:      //正序
        {
            if (self.currentIndex == self.jw_animationImages.count - 1) {
                self.currentIndex = 0;
            }else{
                self.currentIndex ++;
            }
        }
            break;
        case JW3DAnnimationViewStateDescending:     //倒序
        {
            if (self.currentIndex == 0) {
                self.currentIndex = (int)self.jw_animationImages.count - 1;
            }else
            {
                self.currentIndex --;
            }
        }
            break;
        default:
            break;
    }
    
    self.image = self.jw_animationImages[self.currentIndex];
}


#pragma mark - 手势
- (void)addTapGestureRecognizer
{
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pause)];
    [self addGestureRecognizer:tap];
}

- (void)addPanGestureRecognizer
{
    //拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    if (self.rightSwipe) {
        [pan requireGestureRecognizerToFail:self.rightSwipe];
    }
    if (self.leftSwipe) {
        [pan requireGestureRecognizerToFail:self.leftSwipe];
    }
    
    [self addGestureRecognizer:pan];
}

- (void)addSwipeGestureRecognizer
{
    //滑动手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    self.leftSwipe = leftSwipe;
    [self addGestureRecognizer:leftSwipe];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    self.rightSwipe = rightSwipe;
    [self addGestureRecognizer:rightSwipe];
}


#pragma mark - 暂停
-(void)pause
{
    if (self.jw_animating) {
        [self jw_stopAnimating];
    }else
    {
        [self jw_startAnimating];
    }
}

#pragma mark - 拖动图片变化
-(void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    //先暂停
    if (self.jw_animating) {
        [self jw_stopAnimating];
    }
    
    //x 表示在X轴上面偏移的位置
    float perX = self.frame.size.width / self.jw_animationImages.count;
    int offsetIndex = [recognizer translationInView:recognizer.view].x / perX; //偏移的图片张数
    
    int lastIndex;
    int num = offsetIndex % (int)self.jw_animationImages.count;
    if (offsetIndex <= 0) {              //正序
        if (self.currentIndex - num >= self.jw_animationImages.count) {
            lastIndex = self.currentIndex - num - (int)self.jw_animationImages.count;
        }else
        {
            lastIndex = self.currentIndex - num;
        }
    }else
    {                                   //逆序
        if (self.currentIndex - num < 0) {
            lastIndex = (int)self.jw_animationImages.count + self.currentIndex - num;
        }else
        {
            lastIndex = self.currentIndex - num;
        }
    }
    self.image = self.jw_animationImages[lastIndex];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.currentIndex = lastIndex;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - 轻扫顺序倒序播放
-(void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if (!self.jw_animating) {
        [self jw_startAnimating];
    }
    
    //顺序播放
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.jw_animationState = JW3DAnnimationViewStateAscending;
    }
    //逆序播放
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        self.jw_animationState = JW3DAnnimationViewStateDescending;
    }
}

-(void)dealloc
{
    [self.timer invalidate];
}

@end
