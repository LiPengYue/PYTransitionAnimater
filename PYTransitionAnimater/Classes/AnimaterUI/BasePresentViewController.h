//
//  PresentViewController.h
//  Animation
//
//  Created by 李鹏跃 on 2018/8/24.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePresentViewControllerConfiguration.h"



@interface BasePresentViewController : UIViewController


/**
 对此赋值 才能执行动画
 */
@property (nonatomic,weak) UIView *animationView;

/// 其他配置
@property (nonatomic,strong) BasePresentViewControllerConfiguration *config;

/**
 * 将要dismiss的时候调用
 * @ return 是否 dismiss
 */
- (void) willDismissFunc: (BOOL(^)(BasePresentViewController *presentVC))willDismissBlock;

/**
 * 已经dismiss的时候调用
 */
- (void) didDismissFunc: (void(^)(BasePresentViewController *presentVC))didDismissBlock;

/**
 * 1. 点击背景的button
 * 2. block中的返回值： 是否需要执行dismiss方法
 */
- (void) clickBackgroundButtonFunc: (BOOL(^)(BasePresentViewController *presentVC))clickCallBack;

/**
 present 动画中
 @param block block
 @warning toView 指的是 self.animaterView
 @warning fromeView 指的是 self.presentingViewController
 */
- (void) presetionAnimating: (void(^)(UIView *toView, UIView *fromeView)) block
              andCompletion: (void(^)(UIView *toView, UIView *fromeView)) completion;

/**
 dismiss 动画中
 @param block block
 @warning toView 指的是 self.presentingViewController
 @warning fromeView 指的是 self.animaterView
 */
- (void) dismissAnimating: (void (^)(UIView *toView,UIView *fromeView)) block
            andCompletion: (void(^)(UIView *toView, UIView *fromeView)) completion;
@end


