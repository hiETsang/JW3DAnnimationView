//
//  JW3DAnnimationView.h
//  图片动画Demo
//
//  Created by canoe on 2016/10/17.
//  Copyright © 2016年 轻舟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JW3DAnnimationViewState) {
    JW3DAnnimationViewStateAscending, //正序播放
    JW3DAnnimationViewStateDescending,//倒序播放
};

@interface JW3DAnnimationView : UIImageView
//图片数组
@property (nullable, nonatomic, copy) NSArray<UIImage *> *jw_animationImages;
//动画时间
@property (nonatomic) NSTimeInterval jw_animationDuration;
//动画状态
@property (nonatomic) BOOL jw_animating;
//播放模式
@property (nonatomic) JW3DAnnimationViewState jw_animationState;

//开始和暂停
- (void)jw_startAnimating;
- (void)jw_stopAnimating;

//手势
- (void)addTapGestureRecognizer;        //点击暂停
- (void)addPanGestureRecognizer;        //左右拖动变化
- (void)addSwipeGestureRecognizer;      //扫动顺序变化

@end
