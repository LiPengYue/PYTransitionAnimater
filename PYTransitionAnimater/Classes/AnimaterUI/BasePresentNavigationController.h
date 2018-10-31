//
//  BasePresentNavigationController.h
//  yiapp
//
//  Created by 李鹏跃 on 2018/10/31.
//  Copyright © 2018年 yi23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePresentViewControllerConfiguration.h"

typedef void(^ BasicAnimationBlock)(CABasicAnimation *animation);
@interface BasePresentNavigationController : UINavigationController

/**
 对此赋值 才能执行动画
 */
@property (nonatomic,weak) UIView *animationView;


/**
 * 1. 这个是两个Controller中间的蒙层view
 * 2. 不能被修改
 */
@property (nonatomic,weak,readonly) UIView *containerView;

/// 其他配置
@property (nonatomic,strong) BasePresentViewControllerConfiguration *config;

/**
 * 将要dismiss的时候调用
 * @ return 是否 dismiss
 */
- (void) willDismissFunc: (BOOL(^)(BasePresentNavigationController *presentVC))willDismissBlock;

/**
 * 已经dismiss的时候调用
 */
- (void) didDismissFunc: (void(^)(BasePresentNavigationController *presentVC))didDismissBlock;

/**
 * 1. 点击背景的button
 * 2. block中的返回值： 是否需要执行dismiss方法
 */
- (void) clickBackgroundButtonBlockFunc: (BOOL(^)(BasePresentNavigationController *presentVC))clickCallBack;

/**
 present 动画中
 @param block block
 @warning toView 指的是 self.animaterView
 @warning fromeView 指的是 self.presentingViewController
 */
- (void) presentAnimationBegin: (void(^)(UIView *toView, UIView *fromeView)) block
                 andCompletion: (void(^)(UIView *toView, UIView *fromeView)) completion;

/**
 dismiss 动画中
 @param block block
 @warning toView 指的是 self.presentingViewController
 @warning fromeView 指的是 self.animaterView
 */
- (void) dismissAnimationBegin: (void (^)(UIView *toView,UIView *fromeView)) block
                 andCompletion: (void(^)(UIView *toView, UIView *fromeView)) completion;


/// 外部调用 将要dismissblock
- (BOOL) willDismiss;
- (void) didDismiss;
- (BOOL) clickBackgroundView;
@end
