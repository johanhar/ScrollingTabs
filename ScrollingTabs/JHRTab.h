//
//  JHRTab.h
//  ScrollingTabs
//
//  Created by Johannes Harestad on 18.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHRTab : NSObject

- (NSString *)title;

- (UIImage *)icon;

- (UIImage *)iconHighlighted;

- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title
                         icon:(UIImage *)icon;

- (instancetype)initWithTitle:(NSString *)title
                         icon:(UIImage *)icon
              iconHighlighted:(UIImage *)iconHighlighted;

@end