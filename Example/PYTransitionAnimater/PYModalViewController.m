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
 
    self.config
    .setUpPresentStyle(PresentAnimationStyleRight_left)
    .setUpDismissStyle(DismissAnimationStyleLeft_Right)
    .setUpIsLinkage(true)
    
    //shadow
    .setUpDismissShadowOpacity(0)
    .setUpDismissShadowColor([UIColor colorWithWhite:0 alpha:0])
    .setUpPresentShadowColor([UIColor redColor])
    .setUpDismissShadowOffset(CGSizeMake(1, 1))
    .setUpPresentShadowOffset(CGSizeMake(-10, 10));
    
    self.animationView = self.button;

    [self.view addSubview: self.button];
    self.button.frame = CGRectMake(110, 0, self.view.frame.size.width - 110, self.view.frame.size.height);
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
