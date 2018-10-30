//
//  PresentViewController.m
//  Animation
//
//  Created by 李鹏跃 on 2018/8/24.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BasePresentViewController.h"
#import "Animater.h"

@interface BasePresentViewController ()
@property (nonatomic,strong) Animater *animation_animater;
@property (nonatomic,strong) UIButton *animation_backgroundButton;
@property (nonatomic,assign) CGRect animation_fromeViewFrame;
/// 在present 时 fromeview最终的frame
@property (nonatomic,assign) CGRect animation_presentFromViewFrame;
/// fromeView
@property (nonatomic,strong) UIView *animation_fromeView;

@property (nonatomic,copy) BOOL(^willDismissBlock)(BasePresentViewController *presentVC);
@property (nonatomic,copy) void(^didDismissBlock)(BasePresentViewController *presentVC);
@property (nonatomic,copy) BOOL(^clickBackgroundButtonCallBack)(BasePresentViewController *presentVC);
@property (nonatomic,copy) void(^presetionAnimationBeginBlock)(UIView *toView, UIView *fromeView);
@property (nonatomic,copy) void(^dismissAnimationBeginBlock)(UIView *toView,UIView *fromeView);
@property (nonatomic,copy) void(^dismissAnimatingCompletion)(UIView *toView, UIView *fromeView);
@property (nonatomic,copy) void(^presentAnimatingCompletion)(UIView *toView,UIView *fromeView);

@property (nonatomic,copy) BasicAnimationBlock presentBeginBasicAnimationBlock;
@property (nonatomic,copy) BasicAnimationBlock dismissBeginBasicAnimationBlock;
@end



@implementation BasePresentViewController

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self.animation_animater;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self animater_setup];
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
- (void) animater_setup {
    [self animater_setupAnimater];
    [self animater_setupButton];
}


// MARK: handle views
- (void) animater_setupButton {
    [self.view addSubview:self.backgroundButton];
    self.backgroundButton.frame = self.view.bounds;
    [self.backgroundButton addTarget:self action:@selector(clickBackgroundButtonFunc) forControlEvents:UIControlEventTouchUpInside];
}

- (void) animater_setupAnimater {
    __weak typeof(self) weakSelf = self;
    
    [self.animation_animater setupContainerViewWithBlock:^(UIView *containerView) {
        _containerView = containerView;
    }];
    
    [self.animation_animater presentAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromVC, UIView *toView, UIView *fromView) {
        
        if (!weakSelf.animationView) {
            NSLog(@"🌶 没有设置animationView 不能执行动画");
        }
        
        UIView *view = fromView ? fromView : fromVC.view;
        weakSelf.animation_fromeView = view;
        weakSelf.animation_fromeViewFrame = view.frame;
        switch (weakSelf.config.presentStyle) {
            case PresentAnimationStyleNull:
                weakSelf.animation_animater.isAccomplishAnima = true;
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
    
    [self.animation_animater dismissAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromVC, UIView *toView, UIView *fromView) {
        if (!weakSelf.animationView) {
            NSLog(@"🌶 没有设置animationView 不能执行动画");
        }
        
        switch (weakSelf.config.dismissStyle) {
            case DismissAnimationStyleNull:
                weakSelf.animation_animater.isAccomplishAnima = true;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
// present animation func
- (void) presentAnimation: (void(^)(BasePresentViewController *weakSelf))block
            andCompletionBlock:(void(^)(BasePresentViewController *weakSelf))completion {
    [self present_animationViewShadowAnimation: self.config.presentDuration];
    [self presetionAnimationBeginBlockFunc];
    
    __weak typeof(self)weakSelf = self;
    self.animationView.alpha = self.config.presentStartAlpha;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
     [UIView animateWithDuration:self.config.presentDuration
                           delay:self.config.presentDelayDuration
                         options:self.config.presentAnimationOptions
                      animations:
      ^{
          
         self.animationView.alpha = 1;
         if (block) {
             block(weakSelf);
         }
          self.view.backgroundColor = self.config.backgroundColor;
     } completion:^(BOOL finished) {
         self.animation_animater.isAccomplishAnima = true;
         if (completion) {
             completion(weakSelf);
         }
         [self presentCompletion_animationViewShadowAnimation];
         [self presentCompletionFunc];
     }];
}

- (void) dismiss_animationViewShadowAnimation {
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    
    CABasicAnimation *shadowOffset_anim;
    CABasicAnimation *opacity_anim;
    CABasicAnimation *color_anim;
    
    shadowOffset_anim = [self shadowAnimationWithToOffset:self.config.dismissShadowOffset
                                             andFromValue:self.config.presentShadowOffset];
    opacity_anim = [self shadowAnimationWithOpacity:self.config.dismissShadowOpacity];
    color_anim = [self shadowAnimationWithColor:self.config.dismissShadowColor];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    shadowOffset_anim ? [array addObject:shadowOffset_anim] : nil;
    opacity_anim ? [array addObject:opacity_anim] : nil;
    color_anim ? [array addObject:color_anim] : nil;
    group.animations = array.copy;
    
    group.duration = self.config.dismissDuration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.beginTime = 0;
    
    [self.animationView.layer addAnimation:group forKey:@"group"];
}

- (void) presentCompletion_animationViewShadowAnimation {
    [self present_animationViewShadowAnimation: 0.3];
}

- (void) present_animationViewShadowAnimation: (CGFloat)duration {
    
    self.animationView.layer.shadowOpacity = self.config.dismissShadowOpacity;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    
    CABasicAnimation *shadowOffset_anim;
    CABasicAnimation *opacity_anim;
    CABasicAnimation *color_anim;
    
    shadowOffset_anim = [self shadowAnimationWithToOffset:self.config.presentShadowOffset
                                             andFromValue:self.config.dismissShadowOffset];
    opacity_anim = [self shadowAnimationWithOpacity:self.config.presentShadowOpacity];
    color_anim = [self shadowAnimationWithColor:self.config.presentShadowColor];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    shadowOffset_anim ? [array addObject:shadowOffset_anim] : nil;
    opacity_anim ? [array addObject:opacity_anim] : nil;
    color_anim ? [array addObject:color_anim] : nil;
    group.animations = array.copy;
    
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.beginTime = 0;
    
    [self.animationView.layer addAnimation:group forKey:@"group"];
}

- (CABasicAnimation *) createBasicAnimationWithKey: (NSString *)key {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    return anim;
}

- (CABasicAnimation *) shadowAnimationWithToOffset: (CGSize)toOffset andFromValue: (CGSize) fromOffset {
    if (CGSizeEqualToSize(fromOffset, CGSizeZero)
        && CGSizeEqualToSize(toOffset, CGSizeZero)) {
        return nil;
    }
    
    CABasicAnimation *shadowOffset_anim = [self createBasicAnimationWithKey:@"shadowOffset"];
    shadowOffset_anim.fromValue = [NSValue valueWithCGSize:fromOffset];
    shadowOffset_anim.toValue = [NSValue valueWithCGSize:toOffset];
//    self.animationView.layer.shadowOffset = toOffset;
    return shadowOffset_anim;
}

- (CABasicAnimation *) shadowAnimationWithOpacity: (CGFloat) opacity {
    if (opacity < 0) { return nil; }
    CABasicAnimation *opacity_anim = [self createBasicAnimationWithKey:@"shadowOpacity"];
    self.animationView.layer.shadowOpacity = opacity;
    return opacity_anim;
}
- (CABasicAnimation *) shadowAnimationWithColor: (UIColor *)color {
    if (!color) return nil;
    CABasicAnimation *color_anim = [self createBasicAnimationWithKey:@"shadowColor"];
    self.animationView.layer.shadowColor = color.CGColor;
    return color_anim;
}



- (void) presentCompletionFunc {
    if (self.presentAnimatingCompletion) {
        self.presentAnimatingCompletion(self.animationView, self.animation_fromeView);
    }
}

- (void) presetionAnimationBeginBlockFunc {
    if (self.presetionAnimationBeginBlock) {
        self.presetionAnimationBeginBlock(self.animationView,
                                         self.animation_fromeView);
    }
}
- (void) presentZoomAnimation: (UIView *)fromView
                    andToView: (UIView *)toview {
    
    self.animationView.transform = CGAffineTransformMakeScale(0, 0);
    [self presentAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.transform = CGAffineTransformMakeScale(1, 1);
    } andCompletionBlock:nil];
}

- (void) presentBottom_upAnimationFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    CGRect frame = originFrame;
    frame.origin.y = self.view.frame.size.height;
    self.animationView.frame = frame;
    
    CGRect fromViewFrame = self.presentFromViewFrame;
    if ([self isZeroRect:fromViewFrame]) {
        fromViewFrame = self.animation_fromeViewFrame;
        fromViewFrame.origin.y = fromViewFrame.size.height - frame.origin.y;
    }
    [self presentAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.config.isLinkage) {
            weakSelf.animation_fromeView.frame = fromViewFrame;
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
        fromeViewFrame = self.animation_fromeViewFrame;
        
        fromeViewFrame.origin.x
        = CGRectGetMinX(originFrame)
        - CGRectGetWidth(fromeViewFrame)
        + CGRectGetMinX(fromeViewFrame);
    }
    [self presentAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.config.isLinkage) {
            weakSelf.animation_fromeView.frame = fromeViewFrame;
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
        fromeViewFrame = self.animation_fromeViewFrame;
        fromeViewFrame.origin.y = CGRectGetMaxY(originFrame);
    }
    [self presentAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.config.isLinkage) {
            weakSelf.animation_fromeView.frame = fromeViewFrame;
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
        fromeViewFrame = self.animation_fromeViewFrame;
        fromeViewFrame.origin.x = CGRectGetMaxX(originFrame);
    }
    [self presentAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.frame = originFrame;
        if (weakSelf.config.isLinkage) {
            weakSelf.animation_fromeView.frame = fromeViewFrame;
        }
    } andCompletionBlock:nil];
}

// dismiss animation func
- (void) dismissAnimation:(void(^)(BasePresentViewController *weakSelf))block
       andCompletionBlock:(void(^)(BasePresentViewController *weakSelf))completion {
    [self dismiss_animationViewShadowAnimation];
    [self dismissAnimationBeginBlockFunc];
    
    __weak typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:weakSelf.config.dismissDuration
                           delay:weakSelf.config.dismissDelayDuration
                         options:UIViewAnimationOptionCurveEaseIn
                      animations:
      ^{
          self.animationView.alpha = weakSelf.config.dismissEndAlpha;
          if (block) {
              block(weakSelf);
          }
          self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
      } completion:^(BOOL finished) {
          weakSelf.animation_animater.isAccomplishAnima = true;
          if(completion) {
              completion(weakSelf);
          }
          [weakSelf dismissAnimationCompletionFunc];
      }];
}

- (void) dismissAnimationBeginBlockFunc {
    if (self.dismissAnimationBeginBlock) {
        self.dismissAnimationBeginBlock(self.animation_fromeView,
                                        self.animationView);
    }
}
- (void) dismissAnimationCompletionFunc {
    if (self.dismissAnimatingCompletion) {
        self.dismissAnimatingCompletion(self.animation_fromeView,
                                        self.animationView);
    }
}

- (void) dismissZoomAnimation: (UIView *)fromView andToView: (UIView *)toview {
    [self dismissAnimation:^(BasePresentViewController *weakSelf) {
        weakSelf.animationView.transform = CGAffineTransformMakeScale(0, 0);
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleUp_bottomAnimationFunc {
    CGRect frame = [self getAnimationViewFrame];
    frame.origin.y = self.view.frame.size.height;
    CGRect toviewFrame = self.animation_fromeViewFrame;
    if ([self isZeroRect:toviewFrame]) {
        toviewFrame = self.animation_fromeView.frame;
        toviewFrame.origin.y = 0;
    }
    [self dismissAnimation:^(BasePresentViewController *weakSelf) {
        
        weakSelf.animationView.frame = frame;
        if (weakSelf.config.isLinkage) {
            weakSelf.animation_fromeView.frame = toviewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleBottom_UpFunc {
    CGRect frame = [self getAnimationViewFrame];
    frame.origin.y = -(frame.size.height);
    CGRect toviewFrame = self.animation_fromeViewFrame;
    if ([self isZeroRect:toviewFrame]) {
        toviewFrame = self.animation_fromeView.frame;
        toviewFrame.origin.y = 0;
    }
    [self dismissAnimation:^(BasePresentViewController *weakSelf) {
        
        weakSelf.animationView.frame = frame;
        if (weakSelf.config.isLinkage) {
            weakSelf.animation_fromeView.frame = toviewFrame;
        }
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleLeft_RightFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    originFrame.origin.x = self.view.frame.size.width;
    
    CGRect toFrame = self.animation_fromeViewFrame;
    if ([self isZeroRect:toFrame]) {
        toFrame = self.animation_fromeView.frame;
        toFrame.origin.x = 0;
    }
    
    [self dismissAnimation:^(BasePresentViewController *weakSelf) {
        if (weakSelf.config.isLinkage) {
            weakSelf.animation_fromeView.frame = toFrame;
        }
        weakSelf.animationView.frame = originFrame;
        
    } andCompletionBlock:nil];
}

- (void) dismissAnimationStyleRight_LeftFunc {
    CGRect originFrame = [self getAnimationViewFrame];
    originFrame.origin.x = -CGRectGetWidth(originFrame);
    
    CGRect toFrame = self.animation_fromeViewFrame;
    if ([self isZeroRect:toFrame]) {
        toFrame = self.animation_fromeView.frame;
        toFrame.origin.x = 0;
    }
    
    [self dismissAnimation:^(BasePresentViewController *weakSelf) {
        if (weakSelf.config.isLinkage) {
            weakSelf.animation_fromeView.frame = toFrame;
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
- (Animater *) animation_animater {
    if (!_animation_animater) {
        _animation_animater = [[Animater alloc]initWithModalPresentationStyle:UIModalPresentationCustom];
    }
    return _animation_animater;
}

- (BasePresentViewControllerConfiguration *)config {
    if (!_config) {
        _config = [[BasePresentViewControllerConfiguration alloc] init];
    }
    return _config;
}

- (UIButton *)backgroundButton {
    if (!_animation_backgroundButton) {
        _animation_backgroundButton = [UIButton new];
    }
    return _animation_backgroundButton;
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
        CGFloat w = self.animation_fromeViewFrame.size.width;
        CGFloat h = self.animation_fromeViewFrame.size.height;
        return CGRectMake(x, y, w, h);
    }
    return CGRectZero;
}

- (void) presentAnimationBegin:(void (^)(UIView *, UIView *))block andCompletion:(void (^)(UIView *, UIView *))completion{
    self.presetionAnimationBeginBlock = block;
    self.presentAnimatingCompletion = completion;
}

- (void) dismissAnimationBegin:(void (^)(UIView *, UIView *))block andCompletion:(void (^)(UIView *, UIView *))completion{
    self.dismissAnimationBeginBlock = block;
    self.dismissAnimatingCompletion = completion;
}

- (void) presentBeginBasicAnimation: (BasicAnimationBlock) present {
    self.presentBeginBasicAnimationBlock = present;
}

- (void) dismissBeginBasicAnimation: (BasicAnimationBlock) dismiss {
    self.dismissBeginBasicAnimationBlock = dismiss;
}
@end
