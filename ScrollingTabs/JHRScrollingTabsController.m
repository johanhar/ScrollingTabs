//
//  JHRScrollingTabsController.m
//  ScrollingTabs
//
//  Created by Johannes Harestad on 18.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import "JHRScrollingTabsController.h"
#import "JHRTab.h"

@interface JHRScrollingTabsController()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIViewController *containerViewController;

@end

@implementation JHRScrollingTabsController

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (viewControllers != _viewControllers) {
        _viewControllers = [viewControllers copy];
    }
    [self setup];
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
           containerViewController:(UIViewController *)containerViewController
{
    if (!(self = [super init])) return nil;
    _scrollView = scrollView;
    _containerViewController = containerViewController;
    return self;
}

- (void)setup
{
    /*
    NSArray *viewsToRemove = [_scrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
     */
    
}

@end
