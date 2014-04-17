//
//  JHRContainerViewController.m
//  ScrollingTabs
//
//  Created by Johannes Harestad on 16.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import "JHRContainerViewController.h"

@interface JHRContainerViewController ()

@property (nonatomic) UIPageViewController *pageViewController;

@property (nonatomic) NSMutableArray *identifiers;
@property (nonatomic) NSMutableArray *pages;

@end

@implementation JHRContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _identifiers                    = [[NSMutableArray alloc] init];
    _pages                          = [[NSMutableArray alloc] init];
    
    _pageViewController             = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                    options:nil];
    _pageViewController.delegate    = self;
    _pageViewController.dataSource  = self;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    [_pageViewController setViewControllers:@[vc]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
}

#pragma mark - Instance methods
- (void)addPage:(UIViewController *)viewController
 withIdentifier:(NSString *)identifier
{
    [_pages addObject:viewController];
    [_identifiers addObject:identifier];
}

- (NSArray *)pages
{
    return [_pages copy];
}

- (UIViewController *)pageWithIdentifier:(NSString *)identifier
{
    NSInteger index = [_identifiers indexOfObject:identifier];
    if (index == NSNotFound) return nil;
    return [_pages objectAtIndex:index];
}

- (NSString *)identifierForPage:(UIViewController *)viewController
{
    NSInteger index = [_pages indexOfObject:viewController];
    if (index == NSNotFound) return nil;
    return [_identifiers objectAtIndex:index];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    return vc;
}

#pragma mark - UIPageViewControllerDelegate


@end
