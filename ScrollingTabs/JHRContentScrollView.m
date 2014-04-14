//
//  JHRContentScrollView.m
//  ScrollingTabs
//
//  Created by Johannes Harestad on 14.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import "JHRContentScrollView.h"

@interface JHRContentScrollView()

@property (nonatomic) NSDictionary *pagesDictionary;

@end


@implementation JHRContentScrollView

#pragma mark - Accessors
- (NSArray *)pages
{
    return nil;
}

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Instance methods
- (void)scrollToPage:(NSString *)pageIdentifier
{
    
}

- (void)addPage:(UIView *)page
 withIdentifier:(NSString *)identifier
{
    
}

- (void)addPage:(UIView *)page
 withIdentifier:(NSString *)identifier
        atIndex:(NSInteger)index
{
    
}


@end
