//
//  PresentViewController.m
//  Animation
//
//  Created by 李鹏跃 on 2018/8/24.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BasePresentViewController.h"
#import <Animater.h>

@interface BasePresentViewController ()
@property (nonatomic,strong) Animater *animater;
@property (nonatomic,strong) UIButton *backgroundButton;
@property (nonatomic,assign) CGRect fromeViewFrame;
/// 在present 时 fromeview最终的frame
@property (nonatomic,assign) CGRect presentFromViewFrame;
/// fromeView
@property (nonatomic,strong) UIView *fromeView;

@property (nonatomic,copy) BOOL(^willDismissBlock)(BasePresentViewController *presentVC);
@property (nonatomic,copy) void(^didDismissBlock)(BasePresentViewController *presentVC);
@property (nonatomic,copy) BOOL(^clickBackgroundButtonCallBack)(BasePresentViewController *presentVC);
@property (nonatomic,copy) void(^presetionAnimatingBlock)(UIView *toView, UIView *fromeView);
@property (nonatomic,copy) void(^dismissAnimatingBlock)(UIView *toView,UIView *fromeView);
@property (nonatomic,copy) void(^dismissAnimatingCompletion)(UIView *toView, UIView *fromeView);
@property (nonatomic,copy) void(^presentAnimatingCompletion)(UIView *toView,UIView *fromeView);
@end



@implementation BasePresentViewController

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self.animater;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (CGRect) getAnimationViewFrame {
    CGRect frame = self.animationView.frame;
    if (!frame.size.height || !frame.size.width) {
        [self.view layoutIfNeeded];
        frame = self.animationView.frame;
    }
    return frame;
}

#pragma mark - functions
- (void) setup {
    [self setupAnimater];
    [self setupButton];
}


// MARK: handle views
- (void) setupButton {
    [self.view addSubview:self.backgroundButton];
    self.backgroundButton.frame = self.view.bounds;
    [self.backgroundButton addTarget:self action:@selector(clickBackgroundButtonFunc) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setupAnimater {
    __weak typeof(self) weakSelf = self;
    
    [self.animater setupContainerViewWithBlock:^(UIView *containerView) {
//        [UIView animateWithDuration:0.5 animations:^{
            containerView.backgroundColor = weakSelf.config.backgroundColor;
//        }];
    }];
    
    [self.animater presentAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromVC, UIView *toView, UIView *fromView) {
        
        if (!weakSelf.animationView) {
            NSLog(@"🌶 没有设置animationView 不能执行动画");
        }
        UIView *view = fromView ? fromView : fromVC.view;
        weakSelf.fromeView = view;
        weakSelf.fromeViewFrame = view.frame;
        weakSelf.view.backgroundColor = weakSelf.config.backgroundColor;
        switch (weakSelf.config.presentStyle) {
            case PresentAnimationStyleNull:
                weakSelf.animater.isAccomplishAnima = true;
                break;
            case PresentAnimationStyleZoom:
                [weakSelf presentZoomAnimation: fromView andToView: toView];
            case PresentAnimationStyleBottom_up:
                
                [weakSelf presentBottom_upAnimationFunc];
                break;
            case PresentAnimationStyleUp_Bottom:
                [weakSelf presentAnimationStyleUp_BottomFunc];
                break;
            case PresentAnimationStyleRight_left:
                
                [weakSelf presentAnimationStyleLeftFunc];
                break;
            case PresentAnimationStyleLeft_right:
                [weakSelf presentAnimationStyleLeft_rightFunc];
                break;
        }
    }];
    
    [self.animater dismissAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromVC, UIView *toView, UIView *fromView) {
        if (!weakSelf.animationView) {
            NSLog(@"🌶 没有设置animationView 不能执行动画");
        }
        UIView *view = toView ? toView : toVC.view;
        switch (weakSelf.config.dismissStyle) {
            case DismissAnimationStyleNull:
                weakSelf.animater.isAccomplishAnima = true;
            case DismissAnimationStyleZoom:
                [weakSelf dismissZoomAnimation:fromView andToView:toView];
            case DismissAnimationStyleUp_bottom:
                [weakSelf dismissAnimationStyleUp_bottomAnimationFunc];
                break;
            case DismissAnimationStyleBottom_Up:
                [weakSelf dismissAnimationStyleBottom_UpFunc];
                break;
            case DismissAnimationStyleLeft_Right:{
                
                [weakSelf dismissAnimationStyleLeft_RightFunc];
            }
                break;
            case DismissAnimationStyleRight_Left:
                [weakSelf dismissAnimationStyleRight_LeftFunc];
                break;
        }
    }];
}

- (BOOL) isZeroRect: (CGRect)rect {
    return !rect.size.width && !rect.size.height;
}


// present animation func
- (void) presentAnimation: (void(^)(BasePresentViewController *weakSelf))block
            andCompletionBlock:(void(^)(BasePresentViewController *weakSelf))completion {
    
    __weak typeof(self)weakSelf = self;
    self.animationView.alpha = self.config.presentStartAlpha;
     [UIView animateWithDuration:self.config.presentDuration
                           delay:self.config.presentDelayDuration
                         options:self.config.presentAnimationOptions
                      animations:
      ^{
         self.animationView.alpha = 1;
          if (self.presetionAnimatingBlock) {
              self.presentAnimatingCompletion(self.animationView, self.fromeView);
          }
         if (block) {
             block(weakSelf);
         }
     } completion:^(BOOL finished) {
         self.animater.isAccomplishAnima = true;
         if (self.presentAnimatingCompletion) {
             self.presentAnimatingCompletion(self.animationView, self.fromeView);
         }
         
         if (completion) {
             completion(weakSelf);
         }
     }];
}

- (void) presentZoomAnimation: (UIView *)fromView
                    andToView: (UIView *)toview {
    
    self.animationView.transform = CGAffineTransformMakeScale(0, 0);
    self.animationView.alpha = 0;
    [self presentAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.transform = CGAffineTransformMakeScale(1, 1);
        weakSelf.animationView.alpha = 1;
    } andCompletionBlock:nil];
}

- (void) presentBottom_upAnimationFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    CGRect frame = originFrame;
    frame.origin.y = self.view.frame.size.height;
    self.animationView.frame = frame;
    
    CGRect fromViewFrame = self.presentFromViewFrame;
    if ([self isZeroRect:fromViewFrame]) {
        fromViewFrame = self.fromeViewFrame;
        fromViewFrame.origin.y = fromViewFrame.size.height - frame.origin.y;
    }
    [self presentAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.config.isLinkage) {
            weakSelf.fromeView.frame = fromViewFrame;
        }
    } andCompletionBlock:nil];
}


- (void) presentAnimationStyleLeftFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    CGRect frame = originFrame;
    frame.origin.x = self.view.frame.size.width;
    self.animationView.frame = frame;
    CGRect fromeViewFrame = self.presentFromViewFrame;
    if ([self isZeroRect:fromeViewFrame]) {
        fromeViewFrame = self.fromeViewFrame;
        fromeViewFrame.origin.x = -CGRectGetMaxX(originFrame);
    }
    [self presentAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.config.isLinkage) {
            weakSelf.fromeView.frame = fromeViewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) presentAnimationStyleUp_BottomFunc {
    
    CGRect originFrame = [self getAnimationViewFrame];
    CGRect frame = originFrame;
    frame.origin.y = -frame.size.height;
    self.animationView.frame = frame;
    
    CGRect fromeViewFrame = self.presentFromViewFrame;
    if ([self isZeroRect:fromeViewFrame]) {
        fromeViewFrame = self.fromeViewFrame;
        fromeViewFrame.origin.y = CGRectGetMaxY(originFrame);
    }
    [self presentAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.config.isLinkage) {
            weakSelf.fromeView.frame = fromeViewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) presentAnimationStyleLeft_rightFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    CGRect frame = originFrame;
    frame.origin.x = -frame.size.width;
    self.animationView.frame = frame;
    CGRect fromeViewFrame = self.presentFromViewFrame;
    if ([self isZeroRect:fromeViewFrame]) {
        fromeViewFrame = self.fromeViewFrame;
        fromeViewFrame.origin.x = CGRectGetMaxX(originFrame);
    }
    [self presentAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.config.isLinkage) {
            weakSelf.fromeView.frame = fromeViewFrame;
        }
    } andCompletionBlock:nil];
}

// dismiss animation func
- (void) dismissAnimation:(void(^)(BasePresentViewController *weakSelf))block
       andCompletionBlock:(void(^)(BasePresentViewController *weakSelf))completion {
    __weak typeof(self)weakSelf = self;
     [UIView animateWithDuration:self.config.dismissDuration
                           delay:self.config.dismissDelayDuration
                         options:UIViewAnimationOptionCurveEaseIn
                      animations:
      ^{
          self.animationView.alpha = self.config.dismissEndAlpha;
          if (block) {
              block(weakSelf);
          }
          if (self.dismissAnimatingBlock) {
              self.dismissAnimatingBlock(self.fromeView, self.animationView);
          }
      } completion:^(BOOL finished) {
          self.animater.isAccomplishAnima = true;
          if(completion) {
              completion(weakSelf);
          }
          if (self.dismissAnimatingCompletion) {
              self.dismissAnimatingCompletion(self.fromeView, self.animationView);
          }
      }];
}

- (void) dismissZoomAnimation: (UIView *)fromView andToView: (UIView *)toview {
    [self dismissAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.transform = CGAffineTransformMakeScale(0, 0);
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleUp_bottomAnimationFunc {
    CGRect frame = [self getAnimationViewFrame];
    frame.origin.y = self.view.frame.size.height;
    CGRect toviewFrame = self.fromeViewFrame;
    if ([self isZeroRect:toviewFrame]) {
        toviewFrame = self.fromeView.frame;
        toviewFrame.origin.y = 0;
    }
    [self dismissAnimation:^(BasePresentViewController *weakSelf) {
        
        weakSelf.animationView.frame = frame;
        if (weakSelf.config.isLinkage) {
            weakSelf.fromeView.frame = toviewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleBottom_UpFunc {
    CGRect frame = [self getAnimationViewFrame];
    frame.origin.y = -(frame.size.height);
    CGRect toviewFrame = self.fromeViewFrame;
    if ([self isZeroRect:toviewFrame]) {
        toviewFrame = self.fromeView.frame;
        toviewFrame.origin.y = 0;
    }
    [self dismissAnimation:^(BasePresentViewController *weakSelf) {
        
        weakSelf.animationView.frame = frame;
        if (weakSelf.config.isLinkage) {
            weakSelf.fromeView.frame = toviewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleLeft_RightFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    originFrame.origin.x = self.view.frame.size.width;
    
    CGRect toFrame = self.fromeViewFrame;
    if ([self isZeroRect:toFrame]) {
        toFrame = self.fromeView.frame;
        toFrame.origin.x = 0;
    }
    
    [self dismissAnimation:^(BasePresentViewController *weakSelf) {
        if (weakSelf.config.isLinkage) {
            weakSelf.fromeView.frame = toFrame;
        }
        weakSelf.animationView.frame = originFrame;
        
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleRight_LeftFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    originFrame.origin.x = -CGRectGetWidth(originFrame);
    
    CGRect toFrame = self.fromeViewFrame;
    if ([self isZeroRect:toFrame]) {
        toFrame = self.fromeView.frame;
        toFrame.origin.x = 0;
    }
    
    [self dismissAnimation:^(BasePresentViewController *weakSelf) {
        if (weakSelf.config.isLinkage) {
            weakSelf.fromeView.frame = toFrame;
        }
        weakSelf.animationView.frame = originFrame;
        
    } andCompletionBlock:nil];
}


// MARK: handle event
- (void) willDismissFunc: (BOOL(^)(BasePresentViewController *presentVC))willDismissBlock {
    self.willDismissBlock = willDismissBlock;
}

- (void) didDismissFunc: (void(^)(BasePresentViewController *presentVC))didDismissBlock {
    self.didDismissBlock = didDismissBlock;
}

- (void) clickBackgroundButtonFunc:(BOOL (^)(BasePresentViewController *))clickCallBack {
    self.clickBackgroundButtonCallBack = clickCallBack;
}

- (void) clickBackgroundButtonFunc {
    if (self.clickBackgroundButtonCallBack) {
        if (!self.clickBackgroundButtonCallBack(self)) {
            return;
        }
    }
    [self dismissViewControllerAnimated:true completion:nil];
}


// MARK: properties get && set
- (Animater *) animater {
    if (!_animater) {
        _animater = [[Animater alloc]initWithModalPresentationStyle:UIModalPresentationCustom];
    }
    return _animater;
}

- (BasePresentViewControllerConfiguration *)config {
    if (!_config) {
        _config = [[BasePresentViewControllerConfiguration alloc] init];
    }
    return _config;
}

- (UIButton *)backgroundButton {
    if (!_backgroundButton) {
        _backgroundButton = [UIButton new];
    }
    return _backgroundButton;
}


// MARK:life cycles
- (void)dismissViewControllerAnimated:(BOOL)flag
                           completion:(void (^)(void))completion {
    if (self.willDismissBlock) {
        BOOL isDismiss = self.willDismissBlock(self);
        if (!isDismiss) return;
    }
    
    [super dismissViewControllerAnimated:flag completion:^{
        if (self.didDismissBlock) {
            self.didDismissBlock(self);
        }
        if (completion) {
            completion();
        }
    }];
}

- (CGRect) presentFromViewFrame {
    CGFloat x = self.config.presentFromViewX;
    CGFloat y = self.config.presentFromViewY;
    if (x >= 0 || y >= 0) {
        CGFloat w = self.fromeViewFrame.size.width;
        CGFloat h = self.fromeViewFrame.size.height;
        return CGRectMake(x, y, w, h);
    }
    return CGRectZero;
}

- (void) presetionAnimating:(void (^)(UIView *, UIView *))block andCompletion:(void (^)(UIView *, UIView *))completion{
    self.presetionAnimatingBlock = block;
    self.presentAnimatingCompletion = completion;
}

- (void) dismissAnimating:(void (^)(UIView *, UIView *))block andCompletion:(void (^)(UIView *, UIView *))completion{
    self.dismissAnimatingBlock = block;
    self.dismissAnimatingCompletion = completion;
}
@end
