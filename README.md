# JW3DAnnimationView

一个用于实现三维图片效果的简单方式.



 ![demo](/Users/ZBY.JW/Desktop/demo.gif)

# 使用方式:#

- 初始化方式和UIImageView一样
- 不要忘记   ` userInteractionEnabled = YES;`

*根据需要决定是否添加手势*

    [self.annimationView addTapGestureRecognizer];
    [self.annimationView addSwipeGestureRecognizer];
    [self.annimationView addPanGestureRecognizer];
- 开始动画

    -(void)startAnnimation
    {
    [self.annimationView setJw_animationImages:self.imageList];
    [self.annimationView setJw_animationDuration:1.5];
    [self.annimationView jw_startAnimating];
    }


---

有任何问题欢迎指正,有更好的实现方式一定记得联系我.

