//
//  PhotoProductNavigationController.m
//  yiapp
//
//  Created by 李鹏跃 on 2018/10/31.
//  Copyright © 2018年 yi23. All rights reserved.
//

#import "PhotoProductNavigationController.h"
#import "PhotoProductViewController.h"
@interface PhotoProductNavigationController ()

@end

@implementation PhotoProductNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.config
    .setUpPresentStyle(PresentAnimationStyleRight_left)
    .setUpDismissStyle(DismissAnimationStyleLeft_Right)
    .setUpIsLinkage(true)
    //shadow
    .setUpDismissShadowOpacity(0)
    .setUpDismissShadowColor([UIColor colorWithWhite:0 alpha:0])
    .setUpPresentShadowColor([UIColor colorWithWhite:0 alpha:0.06])
    .setUpDismissShadowOffset(CGSizeMake(1, 1))
    .setUpPresentShadowOffset(CGSizeMake(-10, 10));
    
    PhotoProductViewController *vc = [PhotoProductViewController new];
    
    vc.path = self.path;
    vc.product_id = self.product_id;
    
    self.animationView = vc.tableView;
    
    [self setNavigationBarHidden:true animated:false];
    [self addChildViewController:vc];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [super popViewControllerAnimated:animated];
}
@end
