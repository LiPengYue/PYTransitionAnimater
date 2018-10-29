#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AnimatedTransition.h"
#import "Animater.h"
#import "BasePresentViewController.h"
#import "BasePresentViewControllerConfiguration.h"

FOUNDATION_EXPORT double PYTransitionAnimaterVersionNumber;
FOUNDATION_EXPORT const unsigned char PYTransitionAnimaterVersionString[];

