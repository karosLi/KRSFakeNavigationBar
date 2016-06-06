//
//  KRSSwizzle.h
//  KRSFakeNavigationBar
//
//  Created by Karos on 16/5/14.
//  Copyright © 2016年 karosli. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void KRSSwizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector);
