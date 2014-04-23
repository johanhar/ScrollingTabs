//
//  JHRTab.m
//  ScrollingTabs
//
//  Created by Johannes Harestad on 18.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import "JHRTab.h"

@interface JHRTab()

@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *icon;
@property (nonatomic) UIImage *iconHighlighted;

@end

@implementation JHRTab

- (NSString *)title
{
    return _title;
}

- (UIImage *)icon
{
    return _icon;
}

- (UIImage *)iconHighlighted
{
    return _iconHighlighted;
}

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title
                          icon:nil
               iconHighlighted:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                         icon:(UIImage *)icon
{
    return [self initWithTitle:title
                          icon:icon
               iconHighlighted:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                         icon:(UIImage *)icon
              iconHighlighted:(UIImage *)iconHighlighted
{
    if (!(self = [super init])) return nil;
    _title = title;
    _icon = icon;
    _iconHighlighted = iconHighlighted;
    return self;
}


@end
