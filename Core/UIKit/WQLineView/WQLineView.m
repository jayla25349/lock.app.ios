//
//  WQLineView.m
//  Pods
//
//  Created by Jayla on 16/3/10.
//
//

#import "WQLineView.h"

@implementation WQLineView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    UIColor *color = [UIColor lightGrayColor];
    UIImage *lineImage = [UIImage imageWithColor:color];
    self.image = lineImage;
    self.highlightedImage = lineImage;
    self.backgroundColor = [UIColor clearColor];
}

@end
