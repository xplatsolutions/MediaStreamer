//
//  MediaSourceSelectorView.m
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/13/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "MediaSourceSelectorView.h"

@interface MediaSourceSelectorView ()

@property (weak, nonatomic) IBOutlet UIView *view;

@end

@implementation MediaSourceSelectorView
    {
    CGSize _intrinsicContentSize;
    }

NSString* const MediaSourceDidChangedNotification = @"com.mediastreamerxplat.MediaSourceDidChangedNotification";
NSString* const MediaServiceTypeKey = @"com.mediastreamerxplat.MediaServiceTypeKey";

- (UIView*) loadViewFromNib
    {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    UINib* nib = [UINib nibWithNibName:@"MediaSourceSelectorView" bundle:bundle];
    return (UIView*)[nib instantiateWithOwner:self options:nil][0];
    }

#pragma mark -
#pragma mark [ Object Lifecycle ]

- (instancetype) initWithFrame:(CGRect)frame
    {
    if (self = [super initWithFrame:frame])
        {
        [self setupView];
        }
    return self;
    }

- (instancetype) initWithCoder:(NSCoder *)aDecoder
    {
    if (self = [super initWithCoder:aDecoder])
        {
        [self setupView];
        }
    return self;
    }

- (void) setupView
    {
    self.view = [self loadViewFromNib];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.bounds = self.view.bounds;
    _intrinsicContentSize = self.bounds.size;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.view];
    }
    
- (IBAction)mediaSourceValueChanged:(UISegmentedControl *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:MediaSourceDidChangedNotification object:self userInfo: @{ MediaServiceTypeKey: [NSNumber numberWithInteger:sender.selectedSegmentIndex + 1] }];
}

- (CGSize)intrinsicContentSize {
    return _intrinsicContentSize;
}

@end
