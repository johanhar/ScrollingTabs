//
//  JHRScrollingTabsController.h
//  ScrollingTabs
//
//  Created by Johannes Harestad on 18.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHRScrollingTabsController : NSObject

@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic) UIFont *tabsTitleFont;
@property (nonatomic) UIColor *titleColor;
@property (nonatomic) UIColor *titleColorHighlighted;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
           containerViewController:(UIViewController *)containerViewController;

@end
