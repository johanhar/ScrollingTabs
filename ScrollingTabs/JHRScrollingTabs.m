//
//  JHRScrollingTabs.m
//  ScrollingTabs
//
//  Created by Johannes Harestad on 16.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import "JHRScrollingTabs.h"

@interface JHRScrollingTabs()

@property (nonatomic) NSMutableArray *labels;
@property (nonatomic) UIView *wrapper;
@property (nonatomic) UIView *footer;

@end

@implementation JHRScrollingTabs

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self privateInit];
    }
    return self;
}

- (void)privateInit
{
    self.backgroundColor = [UIColor purpleColor];
    
    _labels = [[NSMutableArray alloc] init];
    _wrapper = [[UIView alloc] init];
    _footer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 5, CGRectGetWidth(self.frame), 5)];
    
    _wrapper.layer.borderColor = [UIColor blackColor].CGColor;
    _wrapper.layer.borderWidth = 1;
    _wrapper.backgroundColor = [UIColor redColor];
    
    _footer.backgroundColor = [UIColor greenColor];
    
    _wrapper.translatesAutoresizingMaskIntoConstraints = NO;
    _footer.translatesAutoresizingMaskIntoConstraints = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_wrapper];
    [self addSubview:_footer];
    
    // Center _wrapper X in self
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_wrapper
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_wrapper
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.0
                                                       constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_wrapper
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:-5]];
     
    
    /*
    NSArray *wrapperYConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[wrapper]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"wrapper": _wrapper}];
    [self addConstraints:wrapperYConstraints];
     */
    
    NSArray *labels = @[@"Some stuff", @"Something cool", @"Autolayout ftw"];
    for (NSString *label in labels) {
        UILabel *uilabel = [[UILabel alloc] init];
        uilabel.translatesAutoresizingMaskIntoConstraints = NO;
        uilabel.text = label;
        uilabel.font = [UIFont systemFontOfSize:14];
        [_labels addObject:uilabel];
        [_wrapper addSubview:uilabel];
    }
    
    NSMutableString *vfl = [[NSMutableString alloc] init];
    [vfl setString:@"|"];
    for (int i = 0; i < [_labels count]; i++) {
        if (i == 0) {
            [vfl appendString:[NSString stringWithFormat:@"[label%d]", i]];
        } else {
            [vfl appendString:[NSString stringWithFormat:@"-labelmargin-[label%d]", i]];
        }
    }
    [vfl appendString:@"|"];
    
    NSString *horizontalVfl = [NSString stringWithFormat:@"H:%@", vfl];
    NSDictionary *views = [self dictionaryOfLabelBindings];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:horizontalVfl
                                                                             options:NSLayoutFormatAlignAllBaseline
                                                                             metrics:@{@"labelmargin": @(10)}
                                                                               views:views];
    
    [_wrapper addConstraints:horizontalConstraints];
    
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"label": _labels[0]}];
     
    
    [_wrapper addConstraints:verticalConstraints];
    
    NSLog(@"%@", horizontalVfl);
}

- (NSDictionary *)dictionaryOfLabelBindings
{
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    NSInteger i = 0;
    for (UILabel *label in _labels) {
        NSString *key = [NSString stringWithFormat:@"label%ld", (long)i];
        [d setObject:label forKey:key];
        i++;
    }
    return d;
}

- (void)test
{
    for (UILabel *label in _labels) {
        /*
        CGSize size = [label systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        CGSize size2 = [label intrinsicContentSize];
        CGRect rect = [label alignmentRectForFrame:self.frame];
        CGRect rect2 = [label frameForAlignmentRect:rect];
        NSLog(@"W: %f, H :%f, W2: %f, H2: %f, X: %f, Y: %f", size.width, size.height, size2.width, size2.height, rect2.origin.x, rect2.origin.y);
         */
        UIEdgeInsets uei = [label alignmentRectInsets];
        NSLog(@"Top: %f, Right: %f, Bottom: %f, Left: %f", uei.top, uei.right, uei.bottom, uei.left);
    }
}

@end