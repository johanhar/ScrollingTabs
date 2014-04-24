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
    UIViewController<JHRPage> *en = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *to = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *tre = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *fire = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *fem = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *seks = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *syv = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *atte = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *ni = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    UIViewController<JHRPage> *ti = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    
    en.pageName = @"En";
    to.pageName = @"To";
    tre.pageName = @"Tre";
    fire.pageName = @"Fire";
    fem.pageName = @"Femmmmmmmmmmmmmmmmmm";
    seks.pageName = @"Seks";
    syv.pageName = @"Syv";
    atte.pageName = @"Åtte";
    ni.pageName = @"Ni";
    ti.pageName = @"Ti";
    
    NSArray *viewControllers = @[en,
                                 to,
                                 tre,
                                 fire,
                                 fem,
                                 seks,
                                 syv,
                                 atte,
                                 ni,
                                 ti];
    
    _pagesViewController.viewControllers = viewControllers;
    
    
    _tabsView.tabs          = @[@"En",
                                @"To",
                                @"Tre",
                                @"Fire",
                                @"Femmmmmmmmmmmmmmmmmm",
                                @"Seks",
                                @"Syv",
                                @"Åtte",
                                @"Ni",
                                @"Ti"];

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
    if ([page isEqualToString:@"Fire"]) {
        _tabsView.tabs = @[@"Test", @"hehe", @"hehe", @"hehe", @"hehe", @"hehe", @"hehe", @"hehe", @"hehe", @"hehe", @"hehe", @"hehe"];
        [_tabsView adjustContentSize];
    } else {
        [_tabsView highlightTab:page];
    }
    
}

@end