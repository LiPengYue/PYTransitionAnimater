//
//  PYCustomPresentViewController.m
//  PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/5.
//  Copyright © 2018年 LiPengYue. All rights reserved.
//

#import "PYCustomPresentViewController.h"
@interface PYCustomPresentViewController ()
<
CAAnimationDelegate
>
@property (nonatomic,weak) UIView *toView;
@property (nonatomic,weak) UIView *fromView;
@property (nonatomic,weak) UIViewController *toVc;
@property (nonatomic,weak) UIViewController *fromVc;
@end

@implementation PYCustomPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) customPresentAnimationFuncWithToVc:(UIViewController *)toVc
                                  andToView:(UIView *)toView
                                  andFromVc:(UIViewController *)fromVc
                                andFromView:(UIView *)fromView
                            andAnimaterView:(UIView *)animaterView {
    
    // 动画
    self.toView = toView;
    self.fromView = fromView;
    self.toVc = toVc;
    self.fromVc = fromVc;
    
    switch (self.presentConfig.presentStyle) {
        case PresentAnimationStyle_Shap_round:
            [self presentAnimationStyle_Shap_roundFunc];
            break;
        default:
            [self presentCompletionFunc];
            break;
    }
    
}

- (void) presentAnimationStyle_Shap_roundFunc {
    if (CGRectIsNull(self.toView.frame)) {
        [self.toView layoutIfNeeded];
    }

   CGRect fromFrame =
    CGRectMake(self.fromVc.view.frame.size.width - 100,
               self.fromVc.view.frame.size.height -100,
               100,
               100);
    
    CGPoint fromCenter = CGPointMake(CGRectGetMidX(fromFrame),
                                     CGRectGetMidY(fromFrame));
    
    UIBezierPath *pathFrom =
    [UIBezierPath
     bezierPathWithArcCenter:fromCenter
     radius:50
     startAngle:0
     endAngle:2 * M_PI
     clockwise:true];
    
    UIBezierPath *pathTo = [UIBezierPath
                              bezierPathWithArcCenter:fromCenter
                              radius:self.fromView.frame.size.height * 1.5
                              startAngle:0
                              endAngle:2 * M_PI
                              clockwise:true];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = BaseProxyWeakHandler.createWithTarget(self);
    animation.fromValue = (__bridge id) pathFrom.CGPath;
    animation.toValue = (__bridge id) pathTo.CGPath;
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.beginTime = 0;
    animation.duration = self.presentConfig.presentDuration;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.path = pathFrom.CGPath;
//    [self.toView.layer addSublayer:shapeLayer];
    self.animationView.layer.mask = shapeLayer;
    [shapeLayer addAnimation:animation forKey:@"aaa"];
    [UIView animateWithDuration:self.presentConfig.presentDuration animations:^{
        self.view.backgroundColor = self.presentConfig.backgroundColor;
    }];
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self presentCompletionFunc];
    }
}

@end
