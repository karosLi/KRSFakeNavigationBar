//
//  UIViewController+KRSNavigationBarTransition.m
//  KRSFakeNavigationBar
//
//  Created by Karos on 16/5/14.
//  Copyright © 2016年 karosli. All rights reserved.
//

#import "UIViewController+KRSFakeNavigationBar.h"
#import <objc/runtime.h>
#import "KRSSwizzle.h"

@implementation UIViewController (KRSFakeNavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KRSSwizzleMethod([self class],
                         @selector(viewWillAppear:),
                         @selector(krs_viewWillAppear:));
        
        KRSSwizzleMethod([self class],
                         @selector(viewWillLayoutSubviews),
                         @selector(krs_viewWillLayoutSubviews));
        
        KRSSwizzleMethod([self class],
                         @selector(navigationItem),
                         @selector(krs_navigationItem));
        
        KRSSwizzleMethod([self class],
                         @selector(setTitle:),
                         @selector(setKrs_title:));
    });
}

- (void)krs_viewWillAppear:(BOOL)animated {
    [self krs_AddFakeNavigationBar];
    [self krs_viewWillAppear:animated];
}

- (void)krs_viewWillLayoutSubviews {
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    UIViewController *toViewController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.krs_FakeNavigationBar) {
        if ([self isEqual:self.navigationController.viewControllers.lastObject] && [toViewController isEqual:self]) {
            if (self.krs_FakeNavigationBar.translucent) {
                [tc containerView].backgroundColor = [UIColor whiteColor];
            }
        }
        
        [self krs_resizeFakeNavigationBarFrame];
        [self.view bringSubviewToFront:self.krs_FakeNavigationBar];
    }
    [self krs_viewWillLayoutSubviews];
}

- (UINavigationItem *)krs_navigationItem {
    if (![self krs_EnableFakeNavigationBar]) {
        return self.krs_navigationItem;
    }
    
    if (!self.krs_transitionNavigationItem) {
        self.krs_transitionNavigationItem = [[UINavigationItem alloc] init];
    }
    
    return self.krs_transitionNavigationItem;
}

- (void)setKrs_title:(NSString *)title {
    self.navigationItem.title = title;
    [self setKrs_title:title];
}

- (void)krs_resizeFakeNavigationBarFrame {
    if (!self.view.window) {
        return;
    }
    
    UIView *backgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    if (backgroundView) {
        self.krs_FakeNavigationBar.frame = CGRectMake(0, self.krs_FakeNavigationBarHidden ? -CGRectGetHeight(backgroundView.frame) : 0.0, CGRectGetWidth(backgroundView.frame), CGRectGetHeight(backgroundView.frame));
    }
}

- (void)krs_AddFakeNavigationBar {
    if (!self.krs_FakeNavigationBar && [self krs_EnableFakeNavigationBar]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.krs_FakeNavigationBar = [[UINavigationBar alloc] init];
        self.krs_FakeNavigationBar.items = @[self.navigationItem];
        [self krs_resizeFakeNavigationBarFrame];
        [self.view addSubview:self.krs_FakeNavigationBar];
        
        [self krs_UpdateFakeNavBar];
    }
}

- (void)krs_UpdateFakeNavBar {
    if (self.krs_FakeNavigationBar) {
        UINavigationBar *bar = self.krs_FakeNavigationBar;
        bar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
        bar.barStyle = self.navigationController.navigationBar.barStyle;
        bar.translucent = self.navigationController.navigationBar.translucent;
        bar.barTintColor = self.navigationController.navigationBar.barTintColor;
        bar.backgroundColor = self.navigationController.navigationBar.backgroundColor;
        [bar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        bar.shadowImage = self.navigationController.navigationBar.shadowImage;
    }
}

- (UINavigationBar *)krs_FakeNavigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKrs_FakeNavigationBar:(UINavigationBar *)navigationBar {
    objc_setAssociatedObject(self, @selector(krs_FakeNavigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationItem *)krs_transitionNavigationItem {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKrs_transitionNavigationItem:(UINavigationItem *)navigationItem {
    objc_setAssociatedObject(self, @selector(krs_transitionNavigationItem), navigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)krs_EnableFakeNavigationBar {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKrs_EnableFakeNavigationBar:(BOOL)enable {
    objc_setAssociatedObject(self, @selector(krs_EnableFakeNavigationBar), @(enable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)krs_FakeNavigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKrs_FakeNavigationBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(krs_FakeNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setKrs_NavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    if ([self krs_FakeNavigationBar]) {
        self.krs_FakeNavigationBarHidden = hidden;
        CGRect frame = self.krs_FakeNavigationBar.frame;
        frame.origin.y = hidden ? -frame.size.height : 0.0;
        
        [UIView animateWithDuration:animated ? 0.3 : 0.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.krs_FakeNavigationBar.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

@end
