//
//  PYViewController.m
//  PYTransitionAnimater
//
//  Created by LiPengYue on 12/11/2017.
//  Copyright (c) 2017 LiPengYue. All rights reserved.
//

#import "PYViewController.h"
#import "PYModalViewController.h"
#import <PYTransitionAnimater/BaseAnimaterHeaders.h>

@interface PYViewController ()
@property (nonatomic,strong) UIImageView *button;
@property (nonatomic,strong) UIButton *modalNavigationVC;
@property (nonatomic,strong) UIButton *modalVC;
@end

@implementation PYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button.frame = self.view.bounds;
    self.modalVC.frame = CGRectMake(100, 100, 200, 100);
    self.modalNavigationVC.frame = CGRectMake(100, 400, 200, 100);
    [self.view addSubview:self.button];
    [self.view addSubview:self.modalVC];
    [self.view addSubview:self.modalNavigationVC];
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

}

/// - modalVC Button
- (UIButton *) modalVC {
    if (!_modalVC) {
        _modalVC = [UIButton new];
        [_modalVC setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_modalVC setTitle:@"modalVC" forState:UIControlStateNormal];
        [_modalVC addTarget:self action:@selector(click_modalVCButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modalVC;
}
- (void)click_modalVCButton {
    BasePresentViewController *vc = [PYModalViewController new];
    
    [self presentViewController: vc animated:true completion:nil];
}

/// - modalNavigationVC Button
- (UIButton *) modalNavigationVC {
    if (!_modalNavigationVC) {
        _modalNavigationVC = [UIButton new];
        [_modalNavigationVC setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_modalNavigationVC setTitle:@"modalNavigationVC" forState:UIControlStateNormal];
        [_modalNavigationVC addTarget:self action:@selector(click_modalNavigationVCButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modalNavigationVC;
}
- (void)click_modalNavigationVCButton {
    BasePresentNavigationController *vc = [PYModalViewController new].presentNavigationController;
    
    [self presentViewController: vc animated:true completion:nil];
}
@end

