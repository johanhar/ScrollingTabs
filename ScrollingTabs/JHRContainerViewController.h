//
//  JHRContainerViewController.h
//  ScrollingTabs
//
//  Created by Johannes Harestad on 16.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHRContainerViewControllerDelegate <NSObject>

- (void)didGoToPage:(NSString *)page;

@end

////////////////

@protocol JHRPage <NSObject>

@property (nonatomic) NSString *pageName;

@end

///////////////

@interface JHRContainerViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, weak) id<JHRContainerViewControllerDelegate> pageViewDelegate;
@property (nonatomic, copy) NSArray *viewControllers;
- (void)goToPage:(NSString *)pageName;

@end