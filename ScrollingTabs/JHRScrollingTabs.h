//
//  JHRScrollingTabs.h
//  ScrollingTabs
//
//  Created by Johannes Harestad on 16.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHRScrollingTabsDelegate <NSObject>

// Won't fire if it was highlighted programmatically with highlightTab:tabName
// Won't fire if the tab already was highlighted
- (void)didHighlightTab:(NSString *)tabName;

@end

@interface JHRScrollingTabs : UIScrollView

@property (nonatomic) UIFont *titleFont;
@property (nonatomic) UIColor *titleColor;
@property (nonatomic) UIColor *titleColorHighligthed;
@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) UIColor *trackerColor;
@property (nonatomic) CGFloat trackerHeight;
@property (nonatomic) NSArray *tabs;
@property (nonatomic, weak) id<JHRScrollingTabsDelegate> tabsDelegate;

- (void)setup;
- (void)adjustContentSize;
- (void)highlightTab:(NSString *)tabName;

@end