//
//  JOHAViewController.h
//  ScrollingTabs
//
//  Created by Johannes Harestad on 14.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHRViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *tabs;
@property (weak, nonatomic) IBOutlet UIScrollView *content;

@end
