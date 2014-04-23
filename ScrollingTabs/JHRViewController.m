//
//  JOHAViewController.m
//  ScrollingTabs
//
//  Created by Johannes Harestad on 14.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import "JHRViewController.h"
#import "JHRScrollingTabs.h"

@interface JHRViewController ()

@property (weak, nonatomic) IBOutlet JHRScrollingTabs *tabsView;

@end

@implementation JHRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_tabsView setup];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_tabsView adjustContentSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end