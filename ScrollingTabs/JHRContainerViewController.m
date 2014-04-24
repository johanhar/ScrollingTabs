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

@end

@implementation JHRContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pageViewController             = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                    options:nil];
    _pageViewController.delegate    = self;
    _pageViewController.dataSource  = self;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    if (_viewControllers) {
        UIViewController *vc = [_viewControllers objectAtIndex:0];
        [_pageViewController setViewControllers:@[vc]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    }
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (viewControllers != _viewControllers) {
        _viewControllers = [viewControllers copy];
        
        UIViewController *vc = [_viewControllers objectAtIndex:0];
        [_pageViewController setViewControllers:@[vc]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    }
}

#pragma mark - Instance methods
- (void)goToPage:(NSString *)pageName
{
    for (UIViewController<JHRPage> *page in _viewControllers) {
        if ([page.pageName isEqualToString:pageName]) {
            UIViewController<JHRPage> *currentVc = _pageViewController.viewControllers[0];
            NSInteger currentIndex = [self indexForViewController:currentVc];
            NSInteger newIndex = [self indexForViewController:page];
            
            if (currentIndex == newIndex) {
                return;
            }
            
            UIPageViewControllerNavigationDirection direction = (newIndex < currentIndex) ?
                                                                UIPageViewControllerNavigationDirectionReverse :
                                                                UIPageViewControllerNavigationDirectionForward;
            
            __weak UIPageViewController *pvc = _pageViewController;
            [pvc setViewControllers:@[page]
                          direction:direction
                           animated:YES
                         completion:^(BOOL finished) {
                             UIPageViewController *pvc2 = pvc;
                             if (!pvc2) return;
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [pvc2 setViewControllers:@[page]
                                                direction:direction
                                                 animated:NO
                                               completion:nil];
                             });
                         }];
            
            return;
        }
    }
}

#pragma mark - Helpers
- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    return [_viewControllers objectAtIndex:index];
}

- (NSInteger)indexForViewController:(UIViewController *)vc
{
    return [_viewControllers indexOfObject:vc];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexForViewController:viewController];
    if ((index - 1) < 0) {
        return nil;
    }
    return [self viewControllerAtIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexForViewController:viewController];
    if (index + 1 >= [_viewControllers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index + 1];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (completed) {
        UIViewController<JHRPage> *currentVc = _pageViewController.viewControllers[0];
        [_pageViewDelegate didGoToPage:currentVc.pageName];
    }
}

@end