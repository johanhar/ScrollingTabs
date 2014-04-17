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
@property (nonatomic) UIView *tracker;

@property (nonatomic) NSLayoutConstraint *trackerPositionConstraints;

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
    self.bounces = NO;
    
    _labels = [[NSMutableArray alloc] init];
    _wrapper = [[UIView alloc] init];
    //_footer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 5, CGRectGetWidth(self.frame), 5)];
    _footer = [[UIView alloc] init];
    _tracker = [[UIView alloc] init];
    
    _tracker.backgroundColor = [UIColor blueColor];
    
    _wrapper.layer.borderColor = [UIColor blackColor].CGColor;
    _wrapper.layer.borderWidth = 1;
    _wrapper.backgroundColor = [UIColor redColor];
    
    _footer.backgroundColor = [UIColor greenColor];
    
    _wrapper.translatesAutoresizingMaskIntoConstraints = NO;
    _footer.translatesAutoresizingMaskIntoConstraints = NO;
    _tracker.translatesAutoresizingMaskIntoConstraints = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_wrapper];
    [_wrapper addSubview:_footer];
    [_wrapper addSubview:_tracker];
    
    // Wrapper will start from top of self
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_wrapper
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.0
                                                       constant:0]];
    // Wrapper will have the same height as self
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_wrapper
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:0]];
    
    NSArray *labels = @[@"Some stuff", @"Something cool", @"Autolayout ftw", @"hmmm", @"heahea", @"craaap"];
    //NSArray *labels = @[@"Some stuff", @"Something cool"];
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
    
    // All labels will be horizontally centered in wrapper (they share the same baseline, so we only center first label)
    [_wrapper addConstraint:[NSLayoutConstraint constraintWithItem:_labels[0]
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_wrapper
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    
    CGSize size = [_wrapper systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (size.width <= self.frame.size.width) {
        // Wrapper will be centered in self
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_wrapper
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
    } else {
        // Wrapper will start from left in self
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_wrapper
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    }
    
    NSArray *footerHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[footer]-0-|"
                                                                                   options:0
                                                                                   metrics:0
                                                                                     views:@{@"footer": _footer}];
    
    NSArray *footerVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[footer(==5)]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"footer": _footer}];
    [_wrapper addConstraints:footerHorizontalConstraints];
    [_wrapper addConstraints:footerVerticalConstraints];
    
    
    NSArray *verticalTrackerConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tracker(==10)]-0-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:@{@"tracker": _tracker}];
    [_wrapper addConstraints:verticalTrackerConstraints];
    
    
    
    NSArray *horizontalTrackerConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[tracker(==10)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"tracker": _tracker}];
    [_wrapper addConstraints:horizontalTrackerConstraints];
    
    _trackerPositionConstraints = [NSLayoutConstraint constraintWithItem:_tracker
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_labels[0]
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0];

    [_wrapper addConstraint:_trackerPositionConstraints];
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
    CGSize size = [_wrapper systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    //_footer.frame = CGRectMake(_footer.frame.origin.x - 150, _footer.frame.origin.y, size.width + 300, _footer.frame.size.height);
    [self setContentSize:size];
}

- (void)animateTest
{
    
    [_wrapper removeConstraint:_trackerPositionConstraints];
    
    _trackerPositionConstraints = [NSLayoutConstraint constraintWithItem:_tracker
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_labels[[_labels count] - 1]
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0];
    
    [_wrapper addConstraint:_trackerPositionConstraints];
    
    [UIView animateWithDuration:2 animations:^{
        [self layoutIfNeeded];
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self animateTest];
}

@end