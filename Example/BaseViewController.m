//
//  BaseViewController.m
//  KRSFakeNavigationBar
//
//  Created by Karos on 16/5/14.
//  Copyright © 2016年 karosli. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+KRSFakeNavigationBar.h"

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.krs_EnableFakeNavigationBar = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tabBarController) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else if (self.navigationController && self.navigationController.viewControllers.firstObject != self) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    } else {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)initNavigationLeftItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
}

- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
