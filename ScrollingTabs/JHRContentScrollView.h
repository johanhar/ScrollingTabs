//
//  JHRContentScrollView.h
//  ScrollingTabs
//
//  Created by Johannes Harestad on 14.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHRContentScrollView : UIScrollView

@property (nonatomic, readonly) NSArray *pages;

- (void)scrollToPage:(NSString *)pageIdentifier;

- (void)addPage:(UIView *)page
 withIdentifier:(NSString *)identifier;

- (void)addPage:(UIView *)page
 withIdentifier:(NSString *)identifier
        atIndex:(NSInteger)index;

@end
