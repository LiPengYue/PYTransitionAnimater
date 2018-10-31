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

#import "BasePresentViewController.h"
#import "BasePresentViewControllerConfiguration.h"
#import "PhotoProductNavigationController.h"
#import "AnimatedTransition.h"
#import "Animater.h"

FOUNDATION_EXPORT double PYTransitionAnimaterVersionNumber;
FOUNDATION_EXPORT const unsigned char PYTransitionAnimaterVersionString[];

