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
@property (nonatomic) NSMutableArray *separators;
@property (nonatomic) UIView *wrapper;

@property (nonatomic) UIView *tracker;

@property (nonatomic) NSMutableArray *trackerConstraints;

@property (nonatomic) BOOL tabsCreated;

@end

@implementation JHRScrollingTabs

#pragma mark - Init
// I don't expect anyone to not use Storyboards, implement
// the other inits if needed and call [self privateInit]
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
    _titleFont              = [UIFont systemFontOfSize:12];
    _titleColor             = [UIColor blackColor];
    _titleColorHighligthed  = [UIColor redColor];
    _separatorColor         = [UIColor colorWithWhite:0.5 alpha:0.8];
    _trackerColor           = [UIColor blackColor];
    _trackerHeight          = 2;
    
    _tabsCreated            = NO;
    _labels                 = [[NSMutableArray alloc] init];
    _separators             = [[NSMutableArray alloc] init];
    _wrapper                = [[UIView alloc] init];
    _tracker                = [[UIView alloc] init];
    _trackerConstraints     = [[NSMutableArray alloc] init];
    
    _tabs                   = @[@"Some stuff", @"Some other stuff", @"Heahea", @"Hihi", @"huhu"];
    
    self.translatesAutoresizingMaskIntoConstraints      = NO;
    _tracker.translatesAutoresizingMaskIntoConstraints  = NO;
    _wrapper.translatesAutoresizingMaskIntoConstraints  = NO;
    
    /*
    self.bounces = NO;
    self.alwaysBounceHorizontal = NO;
     */
}

#pragma mark - Creating the tabs and layout
- (void)setup
{
    if (_tabsCreated) {
        [self removeAllSubviews];
    }
    
    [self addSubview:_wrapper];
    [_wrapper addSubview:_tracker];
    
    _tracker.backgroundColor = _trackerColor;
    self.backgroundColor = [UIColor greenColor];
    
    [self setWrappperYPosition];
    [self setWrapperHeight];
    [self createLabels];
    [self createSeparators];
    [self setLabelsXPosition];
    [self setLabelsYPosition];
    [self setSeparatorsHeight];
    [self setSeparatorsYPosition];
    [self setWrapperXPosition];
    [self setInitialTrackerPosition];
    
    _tabsCreated = YES;
}

- (void)adjustContentSize
{
    CGSize size = [_wrapper systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [self setContentSize:size];
}

- (void)highlightTab:(NSString *)tabName
{
    NSInteger index = -1;
    index = [_tabs indexOfObject:tabName];
    UILabel *label = _labels[index];
   
    if (index >= 0 && [label.text isEqualToString:tabName]) {
        [self highlightTabAtIndex:index];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark - Helpers

- (void)highlightTabAtIndex:(NSInteger)index
{
    [_wrapper removeConstraints:_trackerConstraints];
    [_trackerConstraints removeAllObjects];
    
    NSLayoutConstraint *centerConstraints = [NSLayoutConstraint constraintWithItem:_tracker
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_labels[index]
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.0];
    
    NSLayoutConstraint *widthConstraints = [NSLayoutConstraint constraintWithItem:_tracker
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_labels[index]
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    [_trackerConstraints addObject:centerConstraints];
    [_trackerConstraints addObject:widthConstraints];
    [_wrapper addConstraints:_trackerConstraints];
}

- (void)removeAllSubviews
{
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

- (void)setWrappperYPosition
{
    // Wrapper will start from top of self
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_wrapper
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.0
                                                       constant:0]];
}

// Call this after adding the labels so actually have any content..
- (void)setWrapperXPosition
{
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_wrapper
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1.0
                                                       constant:0]];
}

- (void)setWrapperHeight
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_wrapper
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                    constant:0]];
}

// With separator, we also set separator x position here
- (void)setLabelsXPosition
{
    NSMutableString *vfl = [[NSMutableString alloc] init];
    [vfl setString:@"|-10-"];
    for (int i = 0; i < [_labels count]; i++) {
        if (i == 0) {
            [vfl appendString:[NSString stringWithFormat:@"[label%d]", i]];
        } else {
            [vfl appendString:[NSString stringWithFormat:@"-labelmargin-[separator%d(==1)]-labelmargin-[label%d]", i, i]];
        }
    }
    [vfl appendString:@"-10-|"];
    
    NSString *horizontalVfl = [NSString stringWithFormat:@"H:%@", vfl];
    NSDictionary *views = [self dictionaryOfLabelBindings];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:horizontalVfl
                                                                             options:0
                                                                             metrics:@{@"labelmargin": @(10)}
                                                                               views:views];
    [_wrapper addConstraints:horizontalConstraints];
}

- (void)setLabelsYPosition
{
    for (UILabel *label in _labels) {
        [_wrapper addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_wrapper
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
    }
}

- (void)setInitialTrackerPosition
{
    [_trackerConstraints removeAllObjects];
    
    NSString *vfl = [NSString stringWithFormat:@"V:[tracker(==%f)]-0-|", _trackerHeight];
    NSArray *verticalTrackerConstraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:@{@"tracker": _tracker}];
    [_wrapper addConstraints:verticalTrackerConstraints];
    
    [self highlightTabAtIndex:0];
}

- (void)createLabels
{
    for (NSString *tab in _tabs) {
        UILabel *label  = [[UILabel alloc] init];
        label.text      = tab;
        label.font      = _titleFont;
        label.textColor = _titleColor;
        label.userInteractionEnabled = YES;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [_labels addObject:label];
        [_wrapper addSubview:label];
    }
}

- (void)createSeparators
{
    for (int i = 0; i < [_labels count] - 1; i++) {
        UIView *separator           = [[UIView alloc] init];
        separator.backgroundColor   = _separatorColor;
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        [_wrapper addSubview:separator];
        [_separators addObject:separator];
    }
}

- (void)setSeparatorsYPosition
{
    for (UIView *separator in _separators) {
        [_wrapper addConstraint:[NSLayoutConstraint constraintWithItem:separator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_wrapper
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
    }
}

- (void)setSeparatorsHeight
{
    for (UIView *separator in _separators) {
        [_wrapper addConstraint:[NSLayoutConstraint constraintWithItem:separator
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_wrapper
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:0.5
                                                              constant:0.0]];
    }
}

- (NSDictionary *)dictionaryOfLabelBindings
{
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    NSInteger i = 0;
    for (UILabel *label in _labels) {
        NSString *key = [NSString stringWithFormat:@"label%ld", (long)i];
        [d setObject:label forKey:key];
        if (i < [_labels count] - 1) {
            NSString *keySep = [NSString stringWithFormat:@"separator%ld", (long)i + 1];
            [d setObject:_separators[i] forKey:keySep];
        }
        i++;
    }
    return d;
}

@end