//
//  KYLockView.m
//  KyApp
//
//  Created by 青秀斌 on 16/7/21.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "KYLockView.h"

@interface KYLockView ()
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *selectedImageViews;

@property (nonatomic, assign) CGPoint lineEndPoint;
@property (nonatomic, assign) BOOL isTouching;
@end

@implementation KYLockView

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
    _rowSpace = 20.0f;
    _colSpace = 20.0f;
    _itemSize = CGSizeMake(70.0f, 70.0f);
    _edgeInsets = UIEdgeInsetsMake(30.0f, 30.0f, 30.0f, 30.0f);
    _imageViews = [NSMutableArray arrayWithCapacity:9];
    
    _minLengh = 3;
    _showPath = YES;
    _lineWidth = 10.0f;
    _lineColor = [UIColor redColor];
    _normalImage = nil;
    _selectedImage = nil;
    _selectedImageViews = [NSMutableArray array];
    
    self.backgroundColor = [UIColor grayColor];
    __weak typeof(self) weakSelf = self;
    __weak __block UIView *topView = nil;
    __weak __block UIView *leftView = nil;
    
    for (int i=0; i<9; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = i;
        imageView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.4];
        [self addSubview:imageView];
        [self.imageViews addObject:imageView];
        
        __weak UIImageView *weakImageView = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (topView) {
                make.top.equalTo(topView.mas_bottom).offset(weakSelf.rowSpace);
            } else {
                make.top.equalTo(weakSelf).offset(weakSelf.edgeInsets.top);
            }
            
            if (leftView) {
                make.left.equalTo(leftView.mas_right).offset(weakSelf.colSpace);
            } else {
                make.left.equalTo(weakSelf).offset(weakSelf.edgeInsets.left);
            }
            
            if (i==0) {
                make.size.mas_equalTo(weakSelf.itemSize).priorityHigh();
            } else {
                make.size.equalTo(weakSelf.imageViews.firstObject);
            }
            
            if (i%3==2) {
                topView = weakImageView;
                leftView = nil;
            } else {
                leftView = weakImageView;
            }
        }];
    }
    
    [self.imageViews.lastObject mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-weakSelf.edgeInsets.right);
        make.bottom.equalTo(weakSelf).offset(-weakSelf.edgeInsets.bottom);
    }];
}

- (void)drawRect:(CGRect)rect {
    
    
    if (self.isTouching && self.selectedImageViews.count>0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        
        CGContextBeginPath(context);
        
        [self.selectedImageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx==0) {
                CGContextMoveToPoint(context, obj.center.x, obj.center.y);
            } else {
                CGContextAddLineToPoint(context, obj.center.x, obj.center.y);
                CGContextMoveToPoint(context, obj.center.x, obj.center.y);
            }
        }];
        CGContextAddLineToPoint(context, self.lineEndPoint.x, self.lineEndPoint.y);
        
        CGContextStrokePath(context);
    }
    
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.selectedImageViews removeAllObjects];
    
    UITouch *touch = [touches anyObject];
    for (UIImageView *imageView in self.imageViews) {
        CGPoint touchPoint = [touch locationInView:imageView];
        if ([imageView pointInside:touchPoint withEvent:nil]) {
            [self.selectedImageViews addObject:imageView];
            
            self.isTouching = YES;
            [self setNeedsDisplay];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    self.lineEndPoint = [touch locationInView:self];
    
    for (UIImageView *imageView in self.imageViews) {
        if ([self.selectedImageViews containsObject:imageView]) {
            continue;
        }
        
        CGPoint touchPoint = [touch locationInView:imageView];
        if ([imageView pointInside:touchPoint withEvent:nil]) {
            [self.selectedImageViews addObject:imageView];
        }
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isTouching = NO;
    [self setNeedsDisplay];
}

@end
