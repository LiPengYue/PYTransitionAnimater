//
//  PYModalViewController.m
//  PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/10/29.
//  Copyright © 2018年 LiPengYue. All rights reserved.
//

#import "PYModalViewController.h"

@interface PYModalViewController ()
@property (nonatomic,strong) UIButton *button;
@end

@implementation PYModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.config.presentStyle = PresentAnimationStyleRight_left;
    //    self.config.dismissStyle = DismissAnimationStyleLeft_Right;
    //    self.config.presentDuration = 0.2;
    //    self.config.dismissDuration = 0.4;
    //    self.config.presentFromViewX = 110;
    //    self.config.isLinkage = true;
    
    self.config
    .setUpPresentStyle(PresentAnimationStyleLeft_right)
    .setUpDismissStyle(DismissAnimationStyleRight_Left)
    .setUpPresentDuration(0.2)
    .setUpDismissDuration(0.4)
    //    .setUpPresentFromViewX(110)
    //    .setUpPresentFromViewY(1000)
    .setUpIsLinkage(true);
    
    self.animationView = self.button;
    [self.view addSubview: self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(120);
        make.right.bottom.equalTo(self.view).offset(-120);
        
    }];
    //    self.button.frame = CGRectMake(110, 110, 200, 200);
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
        _button.backgroundColor = [UIColor blueColor];
        [_button setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    }
    return _button;
}

- (void)dealloc {
    NSLog(@"✅%@",self);
}
@end
