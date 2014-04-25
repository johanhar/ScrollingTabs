//
//  JOHAViewController.m
//  ScrollingTabs
//
//  Created by Johannes Harestad on 14.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import "JHRViewController.h"

@interface JHRViewController ()

@property (weak, nonatomic) IBOutlet JHRScrollingTabs *tabsView;

// We set this in prepareForSegue
@property (weak, nonatomic) JHRContainerViewController *pagesViewController;

@end

@implementation JHRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tabsView.tabsDelegate = self;
    
    [self createPagesAndTabs];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_tabsView adjustContentSize];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"container"]) {
        _pagesViewController = (JHRContainerViewController *)segue.destinationViewController;
        _pagesViewController.pageViewDelegate = self;
    }
}

- (void)createPagesAndTabs
{
    UIViewController<JHRPage> *one = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *two = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *house = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *car = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *something = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *somethingelse = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    
    one.pageName = @"One";
    two.pageName = @"Two";
    house.pageName = @"House";
    car.pageName = @"Car";
    something.pageName = @"Something";
    somethingelse.pageName = @"Something else";
    
    NSArray *viewControllers = @[one,
                                 two,
                                 house,
                                 car,
                                 something,
                                 somethingelse];
    
    _pagesViewController.viewControllers = viewControllers;
    
    
    _tabsView.tabs          = @[@"One",
                                @"Two",
                                @"House",
                                @"Car",
                                @"Something",
                                @"Something else"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JHRScrollingTabsDelegate
- (void)didHighlightTab:(NSString *)tabName
{
    [_pagesViewController goToPage:tabName];
}

#pragma mark - JHRContainerViewControllerDelegate
- (void)didGoToPage:(NSString *)page
{
    [_tabsView highlightTab:page];
}

@end