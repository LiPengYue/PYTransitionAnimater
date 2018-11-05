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
 
    self.presentConfig
    .setUpPresentStyle(PresentAnimationStyle_Shap_round)
    .setUpDismissStyle(DismissAnimationStyleLeft_Right)
    .setUpPresentDuration(0.4)
    .setUpDismissDuration(0.4)
    .setUpIsLinkage(true);
    
    //shadow
    self.shadowAnimationConfig
    .setUpDismissShadowColor([UIColor blueColor])
    .setUpPresentShadowColor([UIColor redColor])
    .setUpDismissShadowOffset(CGSizeMake(1, 1))
    .setUpPresentShadowOffset(CGSizeMake(-10, 10));
    
    self.animationView = self.button;

    [self.view addSubview: self.button];
    self.button.frame = CGRectMake(110, 0, self.view.frame.size.width - 110, self.view.frame.size.height);
    
    __weak typeof(self)weakSelf = self;
    [self presentAnimationBegin:^(UIView *toView, UIView *fromeView) {
    } andCompletion:^(UIView *toView, UIView *fromeView) {
        [weakSelf.shadowAnimationConfig beginPresentAnimationWithDuration:1];
        
    }];
    [self dismissAnimationBegin:^(UIView *toView, UIView *fromeView) {
        [weakSelf.shadowAnimationConfig beginDismissAnimationWithDuration:2];
    } andCompletion:nil];
    
 
}

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
