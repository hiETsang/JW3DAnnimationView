//
//  ViewController.m
//  图片动画Demo
//
//  Created by canoe on 2016/10/17.
//  Copyright © 2016年 轻舟. All rights reserved.
//

#import "ViewController.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

#import "JW3DAnnimationView.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) NSMutableArray *imageList;

@property (nonatomic ,strong) JW3DAnnimationView *annimationView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //让图片放大缩小 底层加ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    scrollView.center = self.view.center;
    [self.view addSubview:scrollView];
    scrollView.maximumZoomScale = 2.0;
    scrollView.minimumZoomScale = 1.0;
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = NO;
    
    //使用方法和UIimageView一样
    JW3DAnnimationView *imageView = [[JW3DAnnimationView alloc]initWithFrame:scrollView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.annimationView = imageView;
    [self configImageView];
    
    
    [scrollView addSubview:imageView];
    scrollView.contentSize = imageView.bounds.size;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor greenColor];
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"图片下载中...";
    [self.view addSubview:label];
    //图片下载
    self.imageList = [NSMutableArray arrayWithCapacity:36];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.imageDownloader.maxConcurrentDownloads = 1; //并发数设置为1
    for (NSInteger i = 0; i < 36; i++) {
        
        NSString *imageUrl = [NSString stringWithFormat:@"http://m.res.aipp3d.com/101/7d2091a7e8774956b8c2600a33e4dd4f/%ld.jpg",i];
        [manager loadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [self.imageList addObject:image];
            if (self.imageList.count == 36) {
                [label removeFromSuperview];
                [self startAnnimation];
            }
        }];
    }
}

-(void)configImageView
{
    self.annimationView.userInteractionEnabled = YES;
    [self.annimationView addTapGestureRecognizer];
    [self.annimationView addSwipeGestureRecognizer];
    [self.annimationView addPanGestureRecognizer];
}


-(void)startAnnimation
{
    [self.annimationView setJw_animationImages:self.imageList];
    [self.annimationView setJw_animationDuration:1.5];
    [self.annimationView jw_startAnimating];
}



#pragma mark - scrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.annimationView;
}

//以中心点放大缩小
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter =  scrollView.frame.size.width/2.0 , ycenter = scrollView.frame.size.height/2.0;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    [self.annimationView setCenter:CGPointMake(xcenter, ycenter)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
