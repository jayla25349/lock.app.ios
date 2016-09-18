//
//  WQTextView.m
//  Pods
//
//  Created by Jayla on 16/3/23.
//
//

#import "WQTextView.h"

@interface WQTextView ()
@property (nonatomic, strong) NSString *oldText;
@end

@implementation WQTextView

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
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

@end
