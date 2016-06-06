//
//  UIViewController+KRSNavigationBarTransition.h
//  KRSFakeNavigationBar
//
//  Created by Karos on 16/5/14.
//  Copyright © 2016年 karosli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (KRSFakeNavigationBar)

- (UINavigationBar *)krs_FakeNavigationBar;
- (void)setKrs_EnableFakeNavigationBar:(BOOL)enable;
- (void)krs_UpdateFakeNavBar;
- (void)setKrs_NavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
