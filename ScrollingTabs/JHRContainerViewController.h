//
//  JHRContainerViewController.h
//  ScrollingTabs
//
//  Created by Johannes Harestad on 16.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHRContainerViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

// Add a page (at the end)
- (void)addPage:(UIViewController *)viewController
 withIdentifier:(NSString *)identifier;

// Get all pages
- (NSArray *)pages;

// Get the page by it's identifier
- (UIViewController *)pageWithIdentifier:(NSString *)identifier;

// Get identifier for page
- (NSString *)identifierForPage:(UIViewController *)viewController;

@end
