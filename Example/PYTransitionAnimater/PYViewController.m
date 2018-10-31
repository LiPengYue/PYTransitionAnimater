//
//  PYViewController.m
//  PYTransitionAnimater
//
//  Created by LiPengYue on 12/11/2017.
//  Copyright (c) 2017 LiPengYue. All rights reserved.
//

#import "PYViewController.h"
#import "PYModalViewController.h"
@interface PYViewController ()
@property (nonatomic,strong) UIImageView *button;
@end

@implementation PYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button.frame = self.view.bounds;
    [self.view addSubview:self.button];
}

- (UIImageView *)button {
    if (!_button) {
        _button = [UIImageView new];
        _button.image = [UIImage imageNamed:@"2"];
        _button.userInteractionEnabled = true;
        _button.backgroundColor = [UIColor blueColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
        [_button addGestureRecognizer:tap];
    }
    return _button;
}
- (void) click {

    PYModalViewController *vc = [PYModalViewController new];
    
    [self presentViewController:vc animated:true completion:nil];
    
    [vc willDismissFunc: ^ BOOL(BasePresentViewController *presentVC) {
        NSLog(@"1willDismissFunc");
        return true;
    }];
    
    [vc didDismissFunc:^(BasePresentViewController *presentVC) {
        NSLog(@"2didDismissFunc");
    }];
    [vc clickBackgroundButtonBlockFunc:^BOOL(BasePresentViewController *presentVC) {
         NSLog(@"3clickBackgroundButtonFunc");
        return true;
    }];
}
@end
