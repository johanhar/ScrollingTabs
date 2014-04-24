//
//  JHRScrollingTabs.m
//  ScrollingTabs
//
//  Created by Johannes Harestad on 16.04.14.
//  Copyright (c) 2014 Johannes Harestad. All rights reserved.
//

#import "JHRScrollingTabs.h"

static NSInteger buttonMargin = 10;

@interface JHRScrollingTabs()

@property (nonatomic) NSMutableArray *buttons;
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
    _buttons                 = [[NSMutableArray alloc] init];
    _separators             = [[NSMutableArray alloc] init];
    _wrapper                = [[UIView alloc] init];
    _tracker                = [[UIView alloc] init];
    _trackerConstraints     = [[NSMutableArray alloc] init];
    
    _tabs                   = @[@"Some stuff", @"Some other stuff", @"Heahea", @"Hihi", @"huhu", @"hmmm", @"heaheaaaaafafafafafafafafafafa", @"jupps", @"jeppsi peppsi"];
    
    self.translatesAutoresizingMaskIntoConstraints      = NO;
    _tracker.translatesAutoresizingMaskIntoConstraints  = NO;
    _wrapper.translatesAutoresizingMaskIntoConstraints  = NO;
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
    [self createButtons];
    [self createSeparators];
    [self setButtonsXPosition];
    [self setButtonsYPosition];
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
    UIButton *button = _buttons[index];
   
    if (index >= 0 && [button.titleLabel.text isEqualToString:tabName]) {
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
                                                                            toItem:_buttons[index]
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.0];
    
    NSLayoutConstraint *widthConstraints = [NSLayoutConstraint constraintWithItem:_tracker
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_buttons[index]
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    [_trackerConstraints addObject:centerConstraints];
    [_trackerConstraints addObject:widthConstraints];
    [_wrapper addConstraints:_trackerConstraints];
    
    UIButton *button = _buttons[index];
    CGSize size = [button systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGPoint center = button.center;
    
    CGFloat a = center.x - (size.width / 2);
    CGFloat b = center.x + (size.width / 2);
    
    [self adjustContentOffsetToFitBetween:a
                                      and:b];
}

// Not the best method name -_-
- (void)adjustContentOffsetToFitBetween:(CGFloat)a
                                    and:(CGFloat)b
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat left = currentOffset.x;
    CGFloat right = left + self.frame.size.width;
    
    if (left > a - buttonMargin) {
        [self setContentOffset:CGPointMake(a - buttonMargin, 0) animated:YES];
    } else if (b + buttonMargin > right) {
        [self setContentOffset:CGPointMake((b + buttonMargin) - self.frame.size.width, 0) animated:YES];
    }
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

// Call this after adding the buttons so actually have any content..
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
- (void)setButtonsXPosition
{
    NSMutableString *vfl = [[NSMutableString alloc] init];
    [vfl setString:@"|-10-"];
    for (int i = 0; i < [_buttons count]; i++) {
        if (i == 0) {
            [vfl appendString:[NSString stringWithFormat:@"[button%d]", i]];
        } else {
            [vfl appendString:[NSString stringWithFormat:@"-buttonmargin-[separator%d(==1)]-buttonmargin-[button%d]", i, i]];
        }
    }
    [vfl appendString:@"-10-|"];
    
    NSString *horizontalVfl = [NSString stringWithFormat:@"H:%@", vfl];
    NSDictionary *views = [self dictionaryOfButtonBindings];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:horizontalVfl
                                                                             options:0
                                                                             metrics:@{@"buttonmargin": @(buttonMargin)}
                                                                               views:views];
    [_wrapper addConstraints:horizontalConstraints];
}

- (void)setButtonsYPosition
{
    for (UIButton *button in _buttons) {
        [_wrapper addConstraint:[NSLayoutConstraint constraintWithItem:button
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

- (void)createButtons
{
    for (NSString *tab in _tabs) {
        UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:[tab uppercaseString] forState:UIControlStateNormal];
        [button setTitleColor:_titleColor forState:UIControlStateNormal];
        [button setTitleColor:_titleColorHighligthed forState:UIControlStateHighlighted];
        [button.titleLabel setFont:_titleFont];
        [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:button];
        [_wrapper addSubview:button];
    }
}

- (void)createSeparators
{
    for (int i = 0; i < [_buttons count] - 1; i++) {
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

- (NSDictionary *)dictionaryOfButtonBindings
{
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    NSInteger i = 0;
    for (UIButton *button in _buttons) {
        NSString *key = [NSString stringWithFormat:@"button%ld", (long)i];
        [d setObject:button forKey:key];
        if (i < [_buttons count] - 1) {
            NSString *keySep = [NSString stringWithFormat:@"separator%ld", (long)i + 1];
            [d setObject:_separators[i] forKey:keySep];
        }
        i++;
    }
    return d;
}

- (void)buttonTouched:(id)sender
{
    NSInteger index = -1;
    index = [_buttons indexOfObject:sender];
    if (index >= 0) {
        [self highlightTabAtIndex:index];
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

@end