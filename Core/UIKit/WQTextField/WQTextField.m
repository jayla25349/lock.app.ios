//
//  WQTextField.m
//  Pods
//
//  Created by Jayla on 16/3/23.
//
//

#import "WQTextField.h"

@interface WQTextField ()<UITextFieldDelegate>
@property (nonatomic, strong) NSString *oldText;
@end

@implementation WQTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    rect = UIEdgeInsetsInsetRect(rect, self.textEdge);
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect rect = [super editingRectForBounds:bounds];
    rect = UIEdgeInsetsInsetRect(rect, self.textEdge);
    return rect;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.x += self.leftOffset.x;
    rect.origin.y += self.leftOffset.y;
    return rect;
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)setTextEdge:(UIEdgeInsets)textEdge {
    _textEdge = textEdge;
    [self setNeedsDisplay];
}

- (void)setLeftOffset:(CGPoint)leftOffset {
    _leftOffset = leftOffset;
    [self setNeedsDisplay];
}

- (void)setLeftImage:(UIImage *)leftImage {
    _leftImage = leftImage;
    if (leftImage) {
        self.leftViewMode = UITextFieldViewModeAlways;
        
        UIImageView *imageView = (UIImageView *)self.leftView;
        if (![imageView isKindOfClass:[UIImageView class]]) {
            imageView = [[UIImageView alloc] initWithImage:leftImage];
            self.leftView = imageView;
        } else {
            imageView.image = leftImage;
        }
    } else {
        self.leftViewMode = UITextFieldViewModeNever;
    }
}

/**********************************************************************/
#pragma mark - NSNotification
/**********************************************************************/

- (void)textDidChange:(NSNotification *)notification {
    if (self.maxLength > 0 && self.text.length > self.maxLength) {
        self.text = self.oldText;
    } else {
        self.oldText = self.text;
    }
}

/**********************************************************************/
#pragma mark - UITextFieldDelegate
/**********************************************************************/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
