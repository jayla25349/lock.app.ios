//
//  DCLockView.m
//  DCTask
//
//  Created by 青秀斌 on 16/7/21.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCLockView.h"

@interface DCLockView ()
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *selectedImageViews;

@property (nonatomic, assign) CGPoint lineEndPoint;
@property (nonatomic, assign) BOOL isTouching;
@end

@implementation DCLockView

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
    _rowSpace = 30.0f;
    _colSpace = 30.0f;
    _edgeInsets = UIEdgeInsetsMake(30.0f, 30.0f, 30.0f, 30.0f);
    
    _showPath = YES;
    _lineWidth = 1.0f;
    _lineColor = [UIColor redColor];
    _normalImage = [UIImage imageNamed:@"lock_nor"];
    _selectedImage = [UIImage imageNamed:@"lock_sel"];
    
    _imageViews = [NSMutableArray arrayWithCapacity:9];
    _selectedImageViews = [NSMutableArray array];
    
    self.backgroundColor = [UIColor grayColor];
    __weak __block UIView *topView = nil;
    __weak __block UIView *leftView = nil;
    
    for (int i=0; i<9; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = i;
        imageView.image = self.normalImage;
        imageView.highlightedImage = self.selectedImage;
        [self addSubview:imageView];
        [self.imageViews addObject:imageView];
        
        __weak UIImageView *weakImageView = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (topView) {
                make.top.equalTo(topView.mas_bottom).offset(self.rowSpace);
            } else {
                make.top.equalTo(self).offset(self.edgeInsets.top);
            }
            
            if (leftView) {
                make.left.equalTo(leftView.mas_right).offset(self.colSpace);
            } else {
                make.left.equalTo(self).offset(self.edgeInsets.left);
            }
            
            if (i>0) {
                make.size.equalTo(self.imageViews.firstObject);
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
        make.right.equalTo(self).offset(-self.edgeInsets.right);
        make.bottom.equalTo(self).offset(-self.edgeInsets.bottom);
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
            imageView.highlighted = YES;
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
            imageView.highlighted = YES;
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
