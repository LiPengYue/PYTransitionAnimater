//
//  PYModalViewController.m
//  PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/10/29.
//  Copyright © 2018年 LiPengYue. All rights reserved.
//

#import "PYModalViewController.h"

@interface PYModalViewController ()
@property (nonatomic,strong) UIImageView *button;

@end

@implementation PYModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 赋值动画的view
    self.animationView = self.button;
    // present animation config
    [self setupPresentConfig];
    // shadow
    [self setupShadow];
    [self setupAnimationLifeCycles];
    [self setupViews];
}

- (void) setupViews {
    [self.view addSubview: self.button];
    self.button.frame = CGRectMake(110, 0, self.view.frame.size.width - 110, self.view.frame.size.height);
}

#pragma mark - init

#pragma mark - functions

- (void) setup {
    
}

- (void) setupPresentConfig {
    PresentAnimationStyle presentStyle;
    DismissAnimationStyle dismissStyle;
    if (self.isModalNav) {
        presentStyle = PresentAnimationStyleRight_left;
        dismissStyle = DismissAnimationStyleLeft_Right;
    }else{
        presentStyle = PresentAnimationStyle_Shap_round;
        dismissStyle = DismissAnimationStyleUp_bottom;
    }
    self.presentConfig
    .setUpPresentStyle(presentStyle)
    .setUpDismissStyle(dismissStyle)
    .setUpPresentDuration(0.4)
    .setUpDismissDuration(0.4)
    .setUpIsLinkage(true);
}

- (void) setupShadow {
    self.shadowAnimationConfig
    .setUpDismissShadowColor([UIColor blueColor])
    .setUpPresentShadowColor([UIColor blueColor])
    .setUpPresentShadowOpacity(0.4)
    .setUpDismissShadowOpacity(0.2)
    .setUpDismissShadowOffset(CGSizeMake(1, 1))
    .setUpPresentShadowOffset(CGSizeMake(-20, 10))
    .setUpDismissShadowRadius(20)
    .setUpPresentShadowRadius(30);
}

- (void) setupAnimationLifeCycles {
    __weak typeof(self)weakSelf = self;
    [self presentAnimationBegin:^(UIView *toView, UIView *fromeView) {
        // 转场动画将要开始
        NSLog(@"present 转场动画将要开始");
    } andCompletion:^(UIView *toView, UIView *fromeView) {
        NSLog(@"present 转场动画已经结束,开启阴影动画");
        [weakSelf.shadowAnimationConfig beginPresentAnimationWithDuration:0.5];
        
    }];
    
    [self dismissAnimationBegin:^(UIView *toView, UIView *fromeView) {
          NSLog(@"dismiss 转场动画将要开始,开启阴影动画");
        [weakSelf.shadowAnimationConfig beginDismissAnimationWithDuration:2];
    } andCompletion:^(UIView *toView, UIView *fromeView) {
          NSLog(@"dismiss 转场动画已经结束");
    }];
}


//MARK: - lazy load

- (UIImageView *)button {
    if (!_button) {
        _button = [UIImageView new];
        _button.image = [UIImage imageNamed:@"1"];
        _button.userInteractionEnabled = true;
        _button.backgroundColor = [UIColor blueColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
        [_button addGestureRecognizer:tap];
    }
    return _button;
}
- (void) click {
    
}

- (void)dealloc {
    NSLog(@"✅%@",self);
}
@end
