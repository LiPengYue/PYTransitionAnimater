//
//  PYCustomPresentViewController.h
//  PYTransitionAnimater_Example
//
//  Created by 李鹏跃 on 2018/11/5.
//  Copyright © 2018年 LiPengYue. All rights reserved.
//

#import <PYTransitionAnimater/BaseAnimaterHeaders.h>

typedef enum : NSUInteger {
    /// 根据 fromx fromy  来确定圆心，放大圆心半径
    PresentAnimationStyle_Shap_round = 6
} PresentAnimationCustomStyle;

@interface PYCustomPresentViewController : BasePresentViewController

@end
